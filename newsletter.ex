defmodule Newsletter do
  def read_emails(path) do
    String.split(File.read!(path),"\n", trim: true)
  end

  def open_log(path) do
    {_, file} = File.open(path, [:write])
    file
  end

  def log_sent_email(pid, email) do
    IO.puts(pid,email)
  end

  def close_log(pid) do
    File.close(pid)
  end

  def send_newsletter(emails_path, log_path, send_fun) do

    emails = read_emails(emails_path)
    logpid = open_log(log_path)

    Enum.each(emails,fn email ->
      if send_fun.(email) == :ok do
        log_sent_email(logpid, email)
      end
     end)

    close_log(logpid)
  end

end
