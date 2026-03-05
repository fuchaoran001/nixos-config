{
  description = "A simple NixOS flake";

  nixConfig = {
    extra-substituters = [
      # 上海交大镜像（主选）
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # 中科大镜像（备选）
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      # 清华镜像（备选，注意可能有频率限制）
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];

    # 国内镜像使用官方签名，无需额外公钥
    extra-trusted-public-keys = [
      # 如果将来添加非官方源，再在此处添加对应公钥
    ];
  };


  inputs = {
    # NixOS 官方软件源，这里使用 nixos-25.11 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

        # 如果你觉得 GitHub 拉取慢，可以取消下面这行的注释，替换上面的 url
    # nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";

  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # TODO 请将下面的 my-nixos 替换成你的 hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        # 这里导入之前我们使用的 configuration.nix，
        # 这样旧的配置文件仍然能生效
        ./configuration.nix
      ];
    };
  };
}
