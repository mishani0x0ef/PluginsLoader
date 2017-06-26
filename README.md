# PluginsLoader
Simple library for load plugins

## Basic Usage

Create your interface for plugin:

```c#
namespace PluginContract
{
    public interface IPlugin
    {
        void DoSomething();
    }
}
```

Create you own implementation of plugin (basically it should be separate Assembly):

```c#
using PluginContract;

namespace PluginAssembly
{
    public class Plugin : IPlugin
    {
        public void DoSomething()
        {
            // Your implementation here.
        }
    }
}
```

When you need to load plugins in your code:

```c#
using PluginContract;
// Include PluginsLoader library.
using PluginsLoader;

namespace PluginUsage
{
    public class PluginsConsumer
    {
        public void Test()
        {
            // Get plugins from specific file.
            var plugins = PluginsLoader.Default.LoadFrom("Plugins/MyPlugins/PluginAssembly.dll");
            
            // Get plugins from dir.
            plugins = PluginsLoader.Default.LoadFrom("Plugins/MyPlugins");
            
            // Get plugins from dir recursive.
            plugins = PluginsLoader.Default.LoadFrom("Plugins", true);
        }
    }
}
```
