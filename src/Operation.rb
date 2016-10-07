class Operation
    attr_accessor :value1
    attr_accessor :value2
    attr_accessor :operator

    def initialize(value1=nil, operator=nil, value2=nil)
        @value1 = value1
        @value2 = value2
        @operator = operator
    end

    def toString()
        val1 = @value1
        val2 = @value2
        if @value1.instance_of? Operation
            val1 = val1.toString()
        end
        if @value2.instance_of? Operation
            val2 = val2.toString()
        end
        return "(#{val1} #{@operator} #{val2})"
    end
end
