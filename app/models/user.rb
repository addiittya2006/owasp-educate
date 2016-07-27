class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  # :recoverable, :rememberable, :trackable, :validatable

  Roles = [:admin, :writer]

  # def is?(role)
    # roles.include?(role.to_s)
  # end

  def approve_writer(flag)
    if flag=='true' || flag==1
      self.wflag=true
      if self.save
        return true
      end
    else
      self.wflag=false
      self.save
    end
  end

end
