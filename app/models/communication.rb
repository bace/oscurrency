# == Schema Information
# Schema version: 20090216032013
#
# Table name: communications
#
#  id                   :integer(4)      not null, primary key
#  subject              :string(255)     
#  content              :text            
#  parent_id            :integer(4)      
#  sender_id            :integer(4)      
#  recipient_id         :integer(4)      
#  sender_deleted_at    :datetime        
#  sender_read_at       :datetime        
#  recipient_deleted_at :datetime        
#  recipient_read_at    :datetime        
#  replied_at           :datetime        
#  type                 :string(255)     
#  created_at           :datetime        
#  updated_at           :datetime        
#  conversation_id      :integer(4)      
#

class Communication < ApplicationRecord
end
