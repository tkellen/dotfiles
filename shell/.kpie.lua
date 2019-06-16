if (window_class() == "Atom") then
  workspace(1)
  xy(3840, 0)
  size(3840, 2160)
  maximize()
end
if (window_class() == "Xfce4-terminal") then
  workspace(1)
  xy(0, 0)
  size(3840, 2160)
  maximize()
end
if (window_role() == "browser") then
  workspace(2)
  xy(0,0)
  size(3840, 2160)
  maximize()
end
if (window_class() == "Slack") then
  workspace(2)
  xy(3840, 0)
  size(3840, 2160) 
  maximize()
end
if (window_class() == "zoom") then
  xy(3840, 0)
  workspace(3)
end 
