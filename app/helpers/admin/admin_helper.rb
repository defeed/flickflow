module Admin::AdminHelper
  def is_active? controller
    controller_name == controller ? 'active' : nil
  end
end
