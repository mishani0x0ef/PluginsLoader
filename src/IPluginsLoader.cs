using System.Collections.Generic;

namespace PluginsLoader
{
    public interface IPluginsLoader
    {
        /// <summary>
        /// Load all available plugins that specific type. 
        /// </summary>
        /// <typeparam name="T">Plugin type.</typeparam>
        /// <param name="filePath">Path to folder or file where plugins placed.</param>
        /// <param name="includeSubfolders">Define is plugins from subfolders should be included into results.</param>
        /// <returns>Collection of plugins.</returns>
        IEnumerable<T> LoadFrom<T>(string path, bool includeSubfolders = false) where T : class;
    }
}
