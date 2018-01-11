module LoggerHelpers

  def log_debug(message)
    Tinny.logger.debug message
  end

  def log_info(message)
    Tinny.logger.info message
  end

  def log_warn(message)
    Tinny.logger.warn message
  end

  def log_error(message)
    Tinny.logger.error message
  end

  def log_fatal(message)
    Tinny.logger.fatal message
  end

end