export type WriteFile = {
  path: string
  content: string
}

export type WifiConfig = {
  name: string
  passphrase: string
}

export type K3osCloudInit = {
  ssh_authorized_keys?: string[]
  write_files?: WriteFile[]
  hostname?: string
  init_cmd?: string[]
  boot_cmd?: string[]
  run_cmd?: string[]
  k3os: {
    data_sources?: string[]
    modules?: string[]
    sysctls?: {
      [key: string]: string
    }
    ntp_servers?: string[]
    dns_nameservers?: string[]
    wifi?: WifiConfig[]
    password: string
    server_url?: string
    token?: string
    labels?: {
      [key: string]: string
    }
    k3s_args: string[]
    environment?: {
      [key: string]: string
    }
    taints?: string[]
  }
}
