class Reporter
    attr_reader :title, :text
    attr_accessor :formatter

    def initialize(formatter)
        @title = '月次報告'
        @text = ['順調', '最高の調子']
        @formatter = formatter
    end

    def output_report
        @formatter.output_report(self)
    end
end
