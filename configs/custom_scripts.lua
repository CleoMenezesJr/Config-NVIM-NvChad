local M = {}

M.find_and_replace_all = function(mode)
  local find
  local replace

  vim.ui.input({ prompt = "Find: " }, function(find_input)
    find = find_input
    if find == nil then
      return
    end
    vim.ui.input({ prompt = "Replace: " }, function(replace_input)
      replace = replace_input
      if replace == nil then
        return
      end
      vim.schedule(function()
        vim.cmd("%s/" .. find .. "/" .. replace .. "/" .. mode)
      end)
    end)
  end)
end

M.custom_select_n_virt_text_fold = function(opts)
  local ftMap = {
    vim = "indent",
    python = { "indent" },
    git = "",
  }

  local function custom_selector_handler(bufnr)
    local function handleFallbackException(err, providerName)
      if type(err) == "string" and err:match "UfoFallbackException" then
        return require("ufo").getFolds(bufnr, providerName)
      else
        return require("promise").reject(err)
      end
    end

    return require("ufo")
      .getFolds(bufnr, "lsp")
      :catch(function(err)
        return handleFallbackException(err, "treesitter")
      end)
      :catch(function(err)
        return handleFallbackException(err, "indent")
      end)
  end

  local function custom_virt_text_handler(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ("  %d"):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "Comment" })
    return newVirtText
  end

  -- Custom fold virtual text, which shows number of folded lines
  opts.fold_virt_text_handler = custom_virt_text_handler

  -- Custom provider selector which should go lsp->treesitter->indent
  opts.provider_selector = function(_, filetype, _)
    return ftMap[filetype] or custom_selector_handler
  end
end

return M
