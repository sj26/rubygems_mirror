class PackagesController < ApplicationController
  before_action :prepare_version
  before_action :prepare_package

  def show
    send_file @version.package_path, format: :gemspec
  end

  def specification
    respond_to do |format|
      format.yaml { send_data @package.metadata_yaml }
      format.gemspec { send_data @package.metadata.to_ruby }
    end
  end

  def browse
    @entry = @package[path_param]
  end

  def raw
    @package.data_file(path_param) do |file|
      send_data file.data, filename: file.name, type: file.content_type, disposition: file.disposition
    end
  end

private

  def version_param
    params.require(:version_id)
  end

  def path_param
    request.path_parameters[:path].to_s.tap { |path| Rails.logger.info "path: #{path.inspect}" }
  end

  helper_method :version_param, :path_param

  def prepare_version
    @version = Version.find_by_full_name!(version_param)
  end

  def prepare_package
    @package = @version.package
  end
end
