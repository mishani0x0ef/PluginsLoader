using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;

namespace PluginsLoader
{
    /// <summary>
    /// Default implementation of plugins loader.
    /// </summary>
    public class DefaultPluginsLoader : IPluginsLoader
    {
        private const string PluginsFileNamePattern = "*.dll";

        public IEnumerable<T> LoadFrom<T>(string path, bool includeSubfolders = false) where T : class
        {
            if (Directory.Exists(path))
            {
                return LoadPluginsFromDirectory<T>(path, includeSubfolders);
            }
            else if (File.Exists(path))
            {
                return LoadPluginsFromFile<T>(path);
            }
            else
            {
                throw new DirectoryNotFoundException();
            }
        }

        private IEnumerable<T> LoadPluginsFromDirectory<T>(string dirPath, bool includeSubfolders) where T : class
        {
            var searchOptions = includeSubfolders
                   ? SearchOption.AllDirectories
                   : SearchOption.TopDirectoryOnly;

            var files = Directory.GetFiles(dirPath, PluginsFileNamePattern, searchOptions);

            foreach (var file in files)
            {
                var plugins = LoadPluginsFromFile<T>(file);
                foreach (var plugin in plugins)
                {
                    yield return plugin;
                }
            }
        }

        private IEnumerable<T> LoadPluginsFromFile<T>(string filePath) where T: class
        {
            var assemblyName = AssemblyName.GetAssemblyName(filePath);
            var assembly = Assembly.Load(assemblyName);

            if (assembly == null)
            {
                yield break;
            }

            var targetType = typeof(T);

            var assemblyTypes = assembly.GetTypes();
            foreach (var type in assemblyTypes)
            {
                if (type.IsAbstract || type.IsInterface || type.GetInterface(targetType.Name) == null)
                {
                    continue;
                }

                if (Activator.CreateInstance(type) is T instance)
                {
                    yield return instance;
                }
            }
        }
    }
}
