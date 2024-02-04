return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local dap = require("dap")

    local install_root_dir = vim.fn.stdpath("data") .. "/mason"
    local extension_path = install_root_dir .. "/packages/codelldb/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = codelldb_path,
        args = { "--port", "${port}" },
      },
    }
    dap.configurations.c = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
      },
    }
    dap.configurations.cpp = dap.configurations.c

    local dapui = require("dapui")
    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<F5>", dap.continue, {})
    vim.keymap.set("n", "<F6>", dap.terminate, {})
    vim.keymap.set("n", "<F7>", dap.restart, {})
    vim.keymap.set("n", "<F9>", dap.step_into, {})
    vim.keymap.set("n", "<F10>", dap.step_out, {})
    vim.keymap.set("n", "<F12>", dap.step_over, {})
  end,
}
