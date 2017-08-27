class AddPolymorphicAssociationToAttachment < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :attachments, :attachable, polymorphic: true, index: true
  end
end
