{...}:
let
    server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNnvMbwSqRehpSPWcmU1usPnVRpjZiWbc4vgAHg0Ejg";
in
{
    "db-password.age".publicKeys = server;
}
