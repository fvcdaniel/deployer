ActiveAdmin.register User do

  index do                            
    column :id                     
    column :email
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count 
    column :current_sign_in_ip
    column :last_sign_in_ip   
    column "" do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += ''.html_safe
      links
    end
  end

  form do |f|
    f.inputs do
      f.input :email, :input_html => { :disabled => true } 
      f.input :roles, as: :check_boxes, :label => 'Perfil'
      f.input :apps, as: :check_boxes, :label => 'Aplicativos'
    end
    f.actions
  end

end