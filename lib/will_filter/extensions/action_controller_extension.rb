#--
# Copyright (c) 2010-2012 Michael Berkovich
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

module WillFilter
  module ActionControllerExtension
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.before_action :init_will_filter
    end

    module InstanceMethods
      def init_will_filter
        # only if the filters need to be
        return unless WillFilter::Config.user_filters_enabled?

        wf_current_user = nil
        begin
          wf_current_user = eval(WillFilter::Config.current_user_method)
        rescue Exception => ex
          raise WillFilter::FilterException.new("will_filter cannot be initialized because #{WillFilter::Config.current_user_method} failed with: #{ex.message}")
        end

        WillFilter::Config.init(wf_current_user)
      end
    end
  end
end
