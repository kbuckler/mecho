class Mecho
  class Server < EM::Protocols::HeaderAndContentProtocol
    def receive_request(headers, content)
      @start_time = Time.now
      @headers    = headers_2_hash(headers)
      @content    = content

      if dispatched_method = dispatcher
        EM.defer(dispatched_method, on_complete)
      else 
        on_complete.call
      end
    end

    def dispatcher
      case
      when @headers[:x_mecho_sleep] then sleep_proc
      end
    end

    def sleep_proc
      duration = @headers[:x_mecho_sleep].to_i
      Proc.new do 
        sleep(duration)
      end
    end

    def on_complete
      Proc.new do 
        send_data(response_headers + @content + "\n")
        write_log_message
        close_connection_after_writing
      end
    end

    def write_log_message
      puts @headers
      puts @content
    end
    
    def response_headers
      [ "Server: Mecho/0.0.0",
        "X-Mecho-Duration: #{duration}",
        "\n" ].join("\n")
    end

    def duration
      (Time.now.to_f - @start_time.to_f)
    end
  end
end

