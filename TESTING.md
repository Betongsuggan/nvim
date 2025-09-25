# Testing and Debugging

This configuration includes comprehensive testing and debugging support with language-agnostic tooling.

## Features

- **neotest** - Generic test runner that works with multiple languages
- **nvim-dap** - Debug Adapter Protocol for breakpoint debugging  
- **dap-ui** - Visual debugging interface with variables, call stack, etc.
- **dap-virtual-text** - Shows variable values inline during debugging
- **Go support** - Configured with `neotest-go` and `delve` debugger

## Keybindings

All testing and debugging commands use the `<leader>c` (code) prefix for logical grouping.

### 🚀 Frequent Commands (Single Keys)

These are the commands you'll use most often, mapped to single keys after `<leader>c`:

#### Testing
- **`<leader>ct`** - Run test under cursor or nearest test (most common)
- **`<leader>cf`** - Run all tests in current file

#### Debugging  
- **`<leader>cb`** - Toggle breakpoint
- **`<leader>cc`** - Continue debugging
- **`<leader>cs`** - Step over
- **`<leader>ci`** - Step into  
- **`<leader>co`** - Step out

### ⚙️ Less Frequent Commands (Multi-Keys)

Advanced features and UI management use longer key sequences:

#### Test Management (`<leader>ct*`)
- **`<leader>cta`** - Run **a**ll tests in project
- **`<leader>cti`** - Show test adapter **i**nfo (debug/troubleshooting)
- **`<leader>cts`** - Toggle test **s**ummary window
- **`<leader>cto`** - Toggle test **o**utput panel
- **`<leader>ctw`** - **W**atch tests in current file (continuous)
- **`<leader>ctd`** - **D**ebug nearest test

#### Debug Advanced (`<leader>cd*`)
- **`<leader>cdb`** - Set conditional **b**reakpoint
- **`<leader>cdr`** - Toggle debug **R**EPL
- **`<leader>cdu`** - Toggle debug **U**I

## Workflow Examples

### Basic Testing Workflow
1. Write your test
2. `<leader>ct` - Run the test under cursor
3. `<leader>cf` - Run all tests in file  
4. `<leader>cts` - Open test summary to see results

### Debug Workflow
1. `<leader>cb` - Set breakpoint on line
2. `<leader>ctd` - Debug the test (or run your program)
3. `<leader>cc` - Continue to next breakpoint
4. `<leader>cs` - Step over function calls
5. `<leader>ci` - Step into function
6. `<leader>cdu` - Toggle debug UI for variables/call stack

### Continuous Testing
1. `<leader>ctw` - Start watching tests in current file
2. Edit code - tests run automatically on save
3. `<leader>cts` - Check test summary for results

## Language Support

### Go (Built-in)
- Uses `neotest-go` for test discovery and execution
- Supports table tests with `experimental.test_table = true`
- Go debugging via `delve` with launch configurations for:
  - Regular Go programs
  - Go tests  
  - Go modules

### Other Languages
The framework is extensible. To add support for other languages:
1. Add the appropriate neotest adapter to `extraPlugins`
2. Configure the adapter in the `neotest.setup()` call
3. Add debug adapter configuration for the language

## UI Components

### Test Summary Window (`<leader>cts`)
- Tree view of all tests
- Shows pass/fail status with icons
- Navigate and run individual tests
- Expandable test output

### Test Output Panel (`<leader>cto`)
- Detailed output from test runs
- Error messages and stack traces
- Automatically opens on test failures

### Debug UI (`<leader>cdu`)
- **Scopes** - Local/global variables
- **Watches** - Custom expressions to monitor
- **Call Stack** - Function call hierarchy  
- **Breakpoints** - List of all breakpoints
- **REPL** - Interactive debug console

## Troubleshooting

### Tests Not Running?

1. **Check test adapter info**: Use `<leader>cti` to see if adapters loaded correctly
2. **Verify Go installation**: The info command shows if Go binary is found
3. **Check test file structure**: 
   - Go tests should be in `*_test.go` files
   - Test functions should start with `func Test...`
4. **Use test summary**: `<leader>cts` shows discovered tests
5. **Check neotest output**: `<leader>cto` shows detailed error messages

### Common Issues

- **"No tests found"**: Make sure you're in a Go project with proper test files
- **Tests don't run**: Check that the Go toolchain is available in your PATH
- **Debug not working**: Ensure `delve` debugger is installed and accessible

### Debug Commands

- `<leader>cti` - Shows loaded adapters and Go binary status
- `:lua print(vim.inspect(require('neotest').config))` - Full neotest configuration
- `:checkhealth neotest` - Built-in health check (if available)

## Tips

- Use `<leader>ct` liberally while developing - it's the fastest way to test your current work
- Set breakpoints before running `<leader>ctd` for effective debugging
- The debug UI auto-opens when debugging starts and closes when done
- Test watching (`<leader>ctw`) is great for TDD workflows
- Use the test summary (`<leader>cts`) to get an overview of your entire test suite
- If tests aren't detected, try opening the test file and running `<leader>cti` to debug