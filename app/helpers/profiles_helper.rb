module ProfilesHelper
  def profile_avatar profile, size
    if (profile.avatar.attached? rescue false)
      profile.avatar.variant(resize: size)
    else
      size.gsub!('x','/').gsub!('!','')
      "https://picsum.photos/#{size}?grayscale"
    end
  end
end
