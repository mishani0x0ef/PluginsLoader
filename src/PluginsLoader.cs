namespace PluginsLoader
{
    /// <summary>
    /// Provider of plugins loaders.
    /// </summary>
    public static class PluginsLoader
    {
        private static IPluginsLoader _defaultLoader;

        private static object _locker;

        /// <summary>
        /// Default and recommended implementation of pugins loader.
        /// </summary>
        public static IPluginsLoader Default
        {
            get
            {
                if (_defaultLoader != null)
                    return _defaultLoader;

                lock (_locker)
                {
                    return _defaultLoader ?? (_defaultLoader = new DefaultPluginsLoader());
                }
            }
        }
    }
}
