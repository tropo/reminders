class ApiController < ApplicationController
  def check
    
    @reminders = Reminder.where("appointment > ?", Time.now)
    
    @reminders.each do |reminder| 
     
     if reminder.appointment-1.day > Time.now
       
        # Place outbound reminder call
        RestClient.get 'http://api.tropo.com/1.0/sessions', {:params => {
          :action => 'create', 
          :token => '3d5eed33429706408efcc0e92307b044ba2ecb3c2e641f69f9179b54e9d04af908e583112195de9ec7b05b9e', 
          :phonenumber => reminder.phonenumber, 
          :remindermessage => reminder.message}}
      
      else

        # Send SMS
        RestClient.get 'http://api.tropo.com/1.0/sessions', {:params => {
          :action => 'create', 
          :token => '848b6b17c6229844827847b381a4a7e25c72d0750ec751bc0d10072e58eaa12683b6ea0a8aa5e166ee7bfcc8', 
          :phonenumber => reminder.phonenumber, 
          :remindermessage => reminder.message}}
      
      end 
      
    end
    
    if @reminders
      render :text => "sent " + @reminders.length.to_s + " reminders"
    else
      render :text => "no reminders"
    end
  end
end
