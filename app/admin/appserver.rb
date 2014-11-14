ActiveAdmin.register Appserver do

	form do |f|
      f.inputs "Details" do
        f.input :ip
        f.input :port, :label => "Porta"
        f.input :path
        f.input :dpath
        f.input :duser
        f.input :servidor, as: :select, collection: ['TOMCAT', 'JBOSS']
        f.input :type, as: :select, collection: ['Producao', 'Homologacao'], :label => 'Tipo'

      end
      f.actions
    end


end
