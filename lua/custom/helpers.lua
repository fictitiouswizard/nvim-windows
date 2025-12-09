local M = {}

M.get_python_path = function()
  local venv = os.getenv 'VIRTUAL_ENV'
  if venv then
    return venv .. '/Scripts/python.exe'
  end

  local cwd = vim.fn.getcwd()
  local project_venvs = {
    cwd .. '/.venv/Scripts/python.exe',
    cwd .. '/venv/Scripts/python.exe',
  }
  for _, path in ipairs(project_venvs) do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  local nvim_venv = vim.fn.expand '$LOCALAPPDATA/nvim-venv/Scripts/python.exe'
  if vim.fn.filereadable(nvim_venv) == 1 then
    return nvim_venv
  end

  return 'python'
end

return M
