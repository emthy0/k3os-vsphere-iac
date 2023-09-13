/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `wrangler dev src/index.ts` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `wrangler deploy src/index.ts --name my-worker` to deploy your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

export interface Env {
  // Example binding to KV. Learn more at https://developers.cloudflare.com/workers/runtime-apis/kv/
  // MY_KV_NAMESPACE: KVNamespace;
  //
  // Example binding to Durable Object. Learn more at https://developers.cloudflare.com/workers/runtime-apis/durable-objects/
  // MY_DURABLE_OBJECT: DurableObjectNamespace;
  //
  // Example binding to R2. Learn more at https://developers.cloudflare.com/workers/runtime-apis/r2/
  // MY_BUCKET: R2Bucket;
  //
  // Example binding to a Service. Learn more at https://developers.cloudflare.com/workers/runtime-apis/service-bindings/
  // MY_SERVICE: Fetcher;
}
// import { load } from "./ts-yaml"
// import fs from "fs"
import yaml from "yaml"
import { K3osCloudInit } from "./cloud-init"
export default {
  async fetch(
    request: Request,
    env: Env,
    ctx: ExecutionContext
  ): Promise<Response> {
    const { searchParams: reqParams } = new URL(request.url)
    const mode = reqParams.get("mode") == "server" ? "server" : "agent"
    const hostname = reqParams.get("hostname")
    const IPv4 = reqParams.get("ipv4")
    const IPv6 = reqParams.get("ipv6") == "true" ? true : false
    const token = reqParams.get("token")
    const pwd = reqParams.get("pwd")
    const ssh_authorized_keys = reqParams.get("ssh_authorized_keys")?.split(",")
    const ntp_servers = reqParams.get("ntp_servers")?.split(",")
    const dns_nameservers = reqParams.get("dns_nameservers")?.split(",")
    // let file = load<K3osCloudInit>(
    //   fs.readFileSync("./sample_yaml.yaml", "utf-8")
    // )
    let config: K3osCloudInit = {
      ssh_authorized_keys: ssh_authorized_keys,
      // write_files: [],
      // init_cmd: [],
      boot_cmd: [
        "ln -vs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime",
        "echo 'Asia/Bangkok' > /etc/timezone",
      ],
      // run_cmd: [],
      k3os: {
        // data_sources: undefined,
        // modules: [],
        // sysctls: {},
        ntp_servers: ntp_servers,
        dns_nameservers: dns_nameservers,
        password: "rancher",
        k3s_args: [],
        // environment: {},
        // taints: [],
      },
    }

    hostname && (config.hostname = hostname)
    token && (config.k3os.token = token)
    pwd && (config.k3os.password = pwd)
    if (IPv4) {
      const connmanConfig = `[service_eth0]\nType=ethernet\nIPv4=${IPv4}\nIPv6=${
        IPv6 ? "on" : "off"
      }\nNameservers=192.168.50.1`
      !config?.write_files && (config.write_files = [])
      config.write_files?.push({
        path: "/var/lib/connman/default.config",
        content: connmanConfig,
      })
    }
    if (mode == "server") {
      config.k3os.k3s_args.push("server")
      const isClusterInit =
        reqParams.get("isClusterInit") == "true" ? true : false
      if (isClusterInit) config.k3os.k3s_args.push("--cluster-init")
    } else {
      config.k3os.k3s_args.push("agent")
      const serverUrl = reqParams.get("serverUrl")
      serverUrl && (config.k3os.server_url = serverUrl)
    }

    // const doc = new yaml.Document();
    // doc.contents = config;

    return new Response(yaml.stringify(config) as BodyInit, {
      headers: {
        "content-type": "application/yaml; charset=UTF-8",
        "Content-Disposition": "attachment; filename=cloud-init.yaml",
      },
    })
  },
}

