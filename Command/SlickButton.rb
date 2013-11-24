
class SlickButton
    attr_accessor :command

    def initialize(&command)
        @command = command
    end
    
    # Draw button and handle it
    # ...etc

    def on_button_push
        @command.call if @command
    end
end

save_button = SlickButton.new do
    # Save documents
    @command.execute if @command
end
p save_button
