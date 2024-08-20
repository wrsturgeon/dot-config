{
  laptop-name,
  linux-mac,
  nixvim,
  pkgs,
  self,
  system,
}:
{
  configurationRevision = self.rev or self.dirtyRev or null;
}
