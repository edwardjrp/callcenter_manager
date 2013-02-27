require 'spec_helper'

describe "Admin Report Generals" do
  let!(:admin) { create :user , :admin}

  subject { page }

  before { login(admin) }

  describe " Browsing the list" do

    describe 'navigation' do
      it 'should render the reports link in the navbar' do
        visit admin_root_path
        find('.navbar').should have_content('Reportes')
      end

      it 'should lead to the reports index' do
        visit admin_root_path
        within('.navbar'){ click_link('Reportes') }
        should have_content('Listado de reportes generados')
      end
    end

    describe 'display' do
      let!(:report)  { create :report, name: Report.report_types.first }
      before { visit  admin_reports_path }

      it 'should show the reports int the list' do
        find('#reports_list').should have_content(report.name)
        find('#reports_list').should have_link(report.csv_file.file.identifier)
        find('#reports_list').should have_link(report.pdf_file.file.identifier)
      end

      it 'should render the new report link' do
        should have_link('Generar nuevo reporte')
      end

      it 'should render the report type selection links' do
        Report.report_types.each do |report|
          find('#report_types_links').should have_link(report)
        end
      end
    end
  end

  describe 'generating report' do
    before { visit new_admin_report_path }
    
    it 'should render the generate report form' do
      should have_selector('#new_report')
    end
  end
end
