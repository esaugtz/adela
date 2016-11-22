# encoding: utf-8
organization = FactoryGirl.create(:organization, title: 'México Abierto', landing_page: 'http://mxabierto.org/')
organization.create_catalog

FactoryGirl.create(:user, organization: organization)

FactoryGirl.create(:sector, title: 'Educación')
FactoryGirl.create(:sector, title: 'Economía')
FactoryGirl.create(:sector, title: 'Salud')
FactoryGirl.create(:sector, title: 'Seguridad y Justicia')
FactoryGirl.create(:sector, title: 'Infraestructura')
FactoryGirl.create(:sector, title: 'Finanzas y Contrataciones')
FactoryGirl.create(:sector, title: 'Geoespacial')
FactoryGirl.create(:sector, title: 'Energía y Medio Ambiente')
FactoryGirl.create(:sector, title: 'Cultura y Turismo')
FactoryGirl.create(:sector, title: 'Desarrollo Sostenible')
FactoryGirl.create(:sector, title: 'Gobiernos Locales')
FactoryGirl.create(:sector, title: 'Otros')
