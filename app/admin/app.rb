#encoding:utf-8
ActiveAdmin.register App do

  
  form do |f|
    f.inputs do
      f.input :secretaria
      f.input :nome
      f.input :link
      f.input :appservers, as: :check_boxes, :label => 'Servidores de Aplicação / Containers Web (Homologação)', collection: Homologacao.all
      f.input :appservers, as: :check_boxes, :label => 'Servidores de Aplicação / Containers Web', collection: Producao.all
      f.input :users, as: :check_boxes, :label => 'Permissão Deploy'
    end
    f.actions
  end

end
