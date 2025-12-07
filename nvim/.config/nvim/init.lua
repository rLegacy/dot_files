-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.title = true

-- titlestring bullshit
_G.get_file_icon_and_name = function()
  local file_path = vim.fn.expand("%:p")

  if file_path == "" then
    return "[No Name]"
  end

  local file_name = vim.fn.fnamemodify(file_path, ":t")
  if file_name:match(".conf$") then
    return file_name
  end
  if file_name:match(".json$") then
    return file_name
  end
  local devicons = require("nvim-web-devicons")
  local icon, color = devicons.get_icon(file_name)

  if icon then
    -- Optional: You can add color codes here if your terminal supports them
    return icon .. " " .. file_name
  else
    return file_name
  end
end

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("CustomTitleStringGroup", { clear = true }),
  callback = function()
    if vim.bo.buftype == "" and vim.opt.modifiable:get() then
      -- Set your desired title for normal file buffers
      vim.opt.titlestring = '%{fnamemodify(getcwd(), ":t")} ' .. "%{v:lua.get_file_icon_and_name()}"
    else
      -- Clear titlestring for special buffers (like snacks dashboard)
      vim.opt.titlestring = ""
    end
  end,
})
