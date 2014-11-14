#encoding:utf-8
ActiveAdmin.register Role do


  form do |f|
    f.inputs do
      f.input :name, :label => 'Nome'
      f.input :users, as: :check_boxes, :label => 'Usuários'
    end
    f.actions
  end

end