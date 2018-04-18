class JsonWithSilentExceptionsLogFormatter < SemanticLogger::Formatters::Json
  def exception
    return unless log.exception

    # we do not "unwrap" exceptions here - there's Sentry for this
    hash[:exception] = {
      name:      log.exception.class.name,
      message:   log.exception.message,
      # show only app backtrace
      backtrace: Rails.backtrace_cleaner.clean(Array(log.exception.backtrace), :silent)
    }
  end
end
