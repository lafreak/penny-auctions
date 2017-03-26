class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    if resource.provider.nil?
      resource.update_with_password(params)
    else
      resource.update_without_password(params)
    end
  end
end