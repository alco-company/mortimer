# @markup markdown
#
# The Views::Components::PunchClock::Buttons class is a component that renders the buttons 
# required for the punch clock
#
module Views
  class Components::PunchClock::Buttons < Phlex::HTML
    include Phlex::Rails::Helpers::LinkTo

    def initialize( employee_id:, state: )
      @employee_id = employee_id
      @buttons = build_buttons state
    end

    def template
      @buttons.each do |button|
        button( data: {employee_id: @employee_id, action: "click->punch-clock##{button[:tap]}"}, class: "#{button[:css]} rounded-md w-40 px-4 py-4 flex items-center justify-center") do
          span( class: "material-symbols-outlined" ){ "#{button[:icon]}" }
          span { "#{button[:label]}" }
        end
      end
    end

    def build_buttons state
      state ||= "OUT"
      buttons = [
        { tap: "playTap", icon: "play_arrow", label: "IND", css: state == "IN" ? "disabled bg-transparent border-2 cursor-not-allowed" : "bg-green-400 text-gray-50 shadow-md" },
        { tap: "pauseTap", icon: "pause", label: "PAUSE", css: (state == "OUT" || state == "BREAK") ? "disabled bg-transparent border-2 cursor-not-allowed" : "bg-yellow-400 text-gray-50 shadow-md" },
        { tap: "stopTap", icon: "stop", label: "UD", css: (state == "OUT" || state == "BREAK") ? "disabled bg-transparent border-2 cursor-not-allowed" : "bg-blue-400 text-gray-50 shadow-md" },
        { tap: "deleteTap", icon: "logout", label: "LOG UD", css: "bg-red-700 shadow-md" },
      ]
    end

  end
end
