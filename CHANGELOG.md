# Changelog

## [3.7.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.6.0...v3.7.0) (2025-04-10)


### Features

* add missing properties ([#164](https://github.com/CloudNationHQ/terraform-azure-sa/issues/164)) ([e5665bb](https://github.com/CloudNationHQ/terraform-azure-sa/commit/e5665bbde6a6253e046e2ebd5b731d4327f3a43f))

## [3.6.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.5.2...v3.6.0) (2025-03-28)


### Features

* improve contributor visibility ([#161](https://github.com/CloudNationHQ/terraform-azure-sa/issues/161)) ([5331472](https://github.com/CloudNationHQ/terraform-azure-sa/commit/53314720689c406cd7109d56dcae60d91761312e))

## [3.5.2](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.5.1...v3.5.2) (2025-03-28)


### Bug Fixes

* allow storage management policy rules without base_blob action rules ([#157](https://github.com/CloudNationHQ/terraform-azure-sa/issues/157)) ([576ae61](https://github.com/CloudNationHQ/terraform-azure-sa/commit/576ae61ee438a2098be0e28e4ba7638584673b85))

## [3.5.1](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.5.0...v3.5.1) (2025-03-27)


### Bug Fixes

* change default value identity_ids in user assigned identity ([#158](https://github.com/CloudNationHQ/terraform-azure-sa/issues/158)) ([23b8f9b](https://github.com/CloudNationHQ/terraform-azure-sa/commit/23b8f9b3192d2cc8382daaccb92e4e13e3e198a6))

## [3.5.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.4.0...v3.5.0) (2025-03-26)


### Features

* **deps:** bump golang.org/x/net from 0.33.0 to 0.36.0 in /tests ([#152](https://github.com/CloudNationHQ/terraform-azure-sa/issues/152)) ([693161c](https://github.com/CloudNationHQ/terraform-azure-sa/commit/693161c8b3dd3531144c253c61c0145942f6a7b3))


### Bug Fixes

* resolve for_each sensitivity issue in containers, queues and local users ([#155](https://github.com/CloudNationHQ/terraform-azure-sa/issues/155)) ([7cc3ef5](https://github.com/CloudNationHQ/terraform-azure-sa/commit/7cc3ef5fecc650e32736dc7e37890b95dfa5877a))

## [3.4.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.3.1...v3.4.0) (2025-03-24)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#149](https://github.com/CloudNationHQ/terraform-azure-sa/issues/149)) ([5e0aa39](https://github.com/CloudNationHQ/terraform-azure-sa/commit/5e0aa3958aefd436a390123d8e15347fd144d79f))
* format documentation to include type definitions and removed redundant random provider ([#153](https://github.com/CloudNationHQ/terraform-azure-sa/issues/153)) ([72e1889](https://github.com/CloudNationHQ/terraform-azure-sa/commit/72e1889d35c4d84e99b9999835672132427cd828))

## [3.3.1](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.3.0...v3.3.1) (2025-03-10)


### Bug Fixes

* Add list permission to permission scope ([#150](https://github.com/CloudNationHQ/terraform-azure-sa/issues/150)) ([4b992d8](https://github.com/CloudNationHQ/terraform-azure-sa/commit/4b992d871082eb30be4c61d556310f1fdb7ac4a9))

## [3.3.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.2.2...v3.3.0) (2025-01-30)


### Features

* add local user support for shares and containers ([#147](https://github.com/CloudNationHQ/terraform-azure-sa/issues/147)) ([049c6d0](https://github.com/CloudNationHQ/terraform-azure-sa/commit/049c6d01c39d2b83f51bbeb26318a9cf01be00c3))

## [3.2.2](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.2.1...v3.2.2) (2025-01-27)


### Bug Fixes

* make start and expiry properties optional + add Camelcase ignore for SyncSignature ([#144](https://github.com/CloudNationHQ/terraform-azure-sa/issues/144)) ([bc3fcbb](https://github.com/CloudNationHQ/terraform-azure-sa/commit/bc3fcbb8831d14b549c94cbe8482728c12d6b6c6))

## [3.2.1](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.2.0...v3.2.1) (2025-01-17)


### Bug Fixes

* fix re occuring acls on shares and small refactor ([#142](https://github.com/CloudNationHQ/terraform-azure-sa/issues/142)) ([c0d2989](https://github.com/CloudNationHQ/terraform-azure-sa/commit/c0d29893468fe12a219e52714dd22c9435d1bf31))
* ignore syncsignature file share metadata everytime a file changes ([#139](https://github.com/CloudNationHQ/terraform-azure-sa/issues/139)) ([3ac3979](https://github.com/CloudNationHQ/terraform-azure-sa/commit/3ac397963c4efc1e8b73c894cb93243ca973d25f))

## [3.2.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.1.0...v3.2.0) (2025-01-16)


### Features

* add type definitions ([#136](https://github.com/CloudNationHQ/terraform-azure-sa/issues/136)) ([b38a2b4](https://github.com/CloudNationHQ/terraform-azure-sa/commit/b38a2b4ff87ffcdb46092c057f73441c36f41274))

## [3.1.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.0.2...v3.1.0) (2025-01-16)


### Features

* add missing management policies actions in base blob, snapshot and version ([#131](https://github.com/CloudNationHQ/terraform-azure-sa/issues/131)) ([e7ac065](https://github.com/CloudNationHQ/terraform-azure-sa/commit/e7ac06541f4d95c9b0e40f9e738276d07028cdd5))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#130](https://github.com/CloudNationHQ/terraform-azure-sa/issues/130)) ([c613675](https://github.com/CloudNationHQ/terraform-azure-sa/commit/c6136758619d50730f13b473ac54a11db0c9367f))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#134](https://github.com/CloudNationHQ/terraform-azure-sa/issues/134)) ([1461fff](https://github.com/CloudNationHQ/terraform-azure-sa/commit/1461fff0099a611c5a2763ef72ac1270a457df8e))
* remove temporary files when deployment tests fails ([#132](https://github.com/CloudNationHQ/terraform-azure-sa/issues/132)) ([0f728f4](https://github.com/CloudNationHQ/terraform-azure-sa/commit/0f728f48be308fedef10788e00003bb2a53e4ebe))

## [3.0.2](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.0.1...v3.0.2) (2024-12-03)


### Bug Fixes

* remove active directory authentication usage ([#126](https://github.com/CloudNationHQ/terraform-azure-sa/issues/126)) ([69eee8b](https://github.com/CloudNationHQ/terraform-azure-sa/commit/69eee8b70463a8bbe8359426f1d3deb0b9c7aff6))

## [3.0.1](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v3.0.0...v3.0.1) (2024-11-26)


### Bug Fixes

* allow multiple endpoints for private_link_access ([#123](https://github.com/CloudNationHQ/terraform-azure-sa/issues/123)) ([a9546f3](https://github.com/CloudNationHQ/terraform-azure-sa/commit/a9546f35e0cb46313556763657aa71abfea778df))

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v2.2.0...v3.0.0) (2024-11-25)


### ⚠ BREAKING CHANGES

* added missing properties, aligned azure files authentication properties ([#121](https://github.com/CloudNationHQ/terraform-azure-sa/issues/121))

### Features

* added missing properties, aligned azure files authentication properties ([#121](https://github.com/CloudNationHQ/terraform-azure-sa/issues/121)) ([cdfc710](https://github.com/CloudNationHQ/terraform-azure-sa/commit/cdfc71015459cb23773cd72c137c1c2e8be8f2be))

### Bug Fixes

* replaced deprecated properties storage containers and shares ([#118](https://github.com/CloudNationHQ/terraform-azure-sa/issues/118)) ([e7495ce](https://github.com/CloudNationHQ/terraform-azure-sa/commit/e7495ce071b595605d218fe96abd1c531ff89fac))

## [2.2.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v2.1.0...v2.2.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#115](https://github.com/CloudNationHQ/terraform-azure-sa/issues/115)) ([8fe58d3](https://github.com/CloudNationHQ/terraform-azure-sa/commit/8fe58d3669665b53548b9d38e7fcd54132055f13))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v2.0.0...v2.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#113](https://github.com/CloudNationHQ/terraform-azure-sa/issues/113)) ([9779243](https://github.com/CloudNationHQ/terraform-azure-sa/commit/977924389890138d9d1059e65b7b9b9306b15fa4))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#112](https://github.com/CloudNationHQ/terraform-azure-sa/issues/112)) ([c57e4b4](https://github.com/CloudNationHQ/terraform-azure-sa/commit/c57e4b4867e840b1c33299de841f0323367fdd6a))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v1.1.1...v2.0.0) (2024-09-24)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#111](https://github.com/CloudNationHQ/terraform-azure-sa/issues/111)) ([17d5e7f](https://github.com/CloudNationHQ/terraform-azure-sa/commit/17d5e7f216e5eab93720f6ee220a08a7214e0b91))

### Upgrade from v1.1.1 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`

## [1.1.1](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v1.1.0...v1.1.1) (2024-08-20)


### Bug Fixes

* make identity fully optional ([#106](https://github.com/CloudNationHQ/terraform-azure-sa/issues/106)) ([d77dfc4](https://github.com/CloudNationHQ/terraform-azure-sa/commit/d77dfc4f77c776213c7a6ed09622dba61e07745b))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v1.0.0...v1.1.0) (2024-08-15)


### Features

* added code of conduct and security documentation ([#103](https://github.com/CloudNationHQ/terraform-azure-sa/issues/103)) ([755bc3a](https://github.com/CloudNationHQ/terraform-azure-sa/commit/755bc3a342573f140e2b8b6485e301a30297f2d4))

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.23.1...v1.0.0) (2024-08-07)


### ⚠ BREAKING CHANGES

* data structure has changed due to renaming of properties and (output) variables

### Features

* add filesystems adls gen2 and filesystems paths, renaming of properties ([#100](https://github.com/CloudNationHQ/terraform-azure-sa/issues/100)) ([c90774c](https://github.com/CloudNationHQ/terraform-azure-sa/commit/c90774cc50f0c3a6ffda035deb661cd5f57f637c))

### Upgrade from v0.23.x to v1.0

- Update **module reference** to: `version = "~> 1.0"`
- Rename properties in **storage** object:
    * resourcegroup -> resource_group
    * enable_https_traffic_only -> https_traffic_only_enabled
- Rename **variable** (optional):
   * resourcegroup -> resource_group
- Rename **output variable**:
   * subscriptionId -> subscription_id

## [0.23.1](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.23.0...v0.23.1) (2024-08-06)


### Bug Fixes

* updated acl's to map of objects instead of list of objects to allow for multiple acl entries ([#98](https://github.com/CloudNationHQ/terraform-azure-sa/issues/98)) ([fbb544d](https://github.com/CloudNationHQ/terraform-azure-sa/commit/fbb544d843487a1706e53865568d3a5e27598f8a))

## [0.23.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.22.0...v0.23.0) (2024-07-29)


### Features

* add acl support on shares ([#93](https://github.com/CloudNationHQ/terraform-azure-sa/issues/93)) ([97c604e](https://github.com/CloudNationHQ/terraform-azure-sa/commit/97c604e551f62d4c6dab26b84b7126a086aee286))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#91](https://github.com/CloudNationHQ/terraform-azure-sa/issues/91)) ([a93d39d](https://github.com/CloudNationHQ/terraform-azure-sa/commit/a93d39d84035db7d8e08bcd21385d064b6655107))

## [0.22.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.21.0...v0.22.0) (2024-07-04)


### Features

* reduced redundancy and improved error handling extended tests ([#87](https://github.com/CloudNationHQ/terraform-azure-sa/issues/87)) ([b599304](https://github.com/CloudNationHQ/terraform-azure-sa/commit/b5993044e5a6b6d2573ff5a43e59e5ae0e6191aa))
* update contribution docs ([#89](https://github.com/CloudNationHQ/terraform-azure-sa/issues/89)) ([7d94951](https://github.com/CloudNationHQ/terraform-azure-sa/commit/7d9495127865d02e7373b3b4b3468207d0fe0ed6))

## [0.21.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.20.0...v0.21.0) (2024-07-02)


### Features

* modularize azure client initialization in extended test ([#84](https://github.com/CloudNationHQ/terraform-azure-sa/issues/84)) ([6a0f717](https://github.com/CloudNationHQ/terraform-azure-sa/commit/6a0f717dc8509f4f98f573225b337c34bc58fa78))

## [0.20.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.19.0...v0.20.0) (2024-07-02)


### Features

* add issue template ([#81](https://github.com/CloudNationHQ/terraform-azure-sa/issues/81)) ([248abb8](https://github.com/CloudNationHQ/terraform-azure-sa/commit/248abb83b668f3cfc206ef3f3431b4b6ad2bb1b2))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage ([#80](https://github.com/CloudNationHQ/terraform-azure-sa/issues/80)) ([bc7d5d9](https://github.com/CloudNationHQ/terraform-azure-sa/commit/bc7d5d92cd0529a8011fecdf1f0166720e4bf553))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#79](https://github.com/CloudNationHQ/terraform-azure-sa/issues/79)) ([4750e4a](https://github.com/CloudNationHQ/terraform-azure-sa/commit/4750e4a41fa82746d9174819210ac9e131291ff4))

## [0.19.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.18.0...v0.19.0) (2024-06-28)


### Features

* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#73](https://github.com/CloudNationHQ/terraform-azure-sa/issues/73)) ([de83299](https://github.com/CloudNationHQ/terraform-azure-sa/commit/de832990a3058a1d28921652a36eba84c73aadcb))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#74](https://github.com/CloudNationHQ/terraform-azure-sa/issues/74)) ([5ebd049](https://github.com/CloudNationHQ/terraform-azure-sa/commit/5ebd04964e16c2166f94689098d507b10e9007ac))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#75](https://github.com/CloudNationHQ/terraform-azure-sa/issues/75)) ([e865266](https://github.com/CloudNationHQ/terraform-azure-sa/commit/e86526631691586d8471c730826f88a387137611))
* enhance dynamic conditions for blob, queue, and share blocks ([#77](https://github.com/CloudNationHQ/terraform-azure-sa/issues/77)) ([b7182f8](https://github.com/CloudNationHQ/terraform-azure-sa/commit/b7182f8039d965fc81b7b8825c6482da558bcdbd))

## [0.18.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.17.0...v0.18.0) (2024-06-07)


### Features

* add pull request template ([#70](https://github.com/CloudNationHQ/terraform-azure-sa/issues/70)) ([8a590ba](https://github.com/CloudNationHQ/terraform-azure-sa/commit/8a590bae822ddf753fa350ed58a88be9d8d9c6fd))

## [0.17.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.16.1...v0.17.0) (2024-06-07)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#63](https://github.com/CloudNationHQ/terraform-azure-sa/issues/63)) ([f7734f4](https://github.com/CloudNationHQ/terraform-azure-sa/commit/f7734f4de49c7ea0543f9e77bbc8f04a61e1fb31))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#61](https://github.com/CloudNationHQ/terraform-azure-sa/issues/61)) ([4de5cc4](https://github.com/CloudNationHQ/terraform-azure-sa/commit/4de5cc46be51fd285840cc52cfc760c7d0d162fa))


### Bug Fixes

* ensure container access type is fully optional ([#68](https://github.com/CloudNationHQ/terraform-azure-sa/issues/68)) ([17c18dd](https://github.com/CloudNationHQ/terraform-azure-sa/commit/17c18dd2e6e421b7ffd9b30554f2212cfbd1c32b))

## [0.16.1](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.16.0...v0.16.1) (2024-06-07)


### Bug Fixes

* fix handling of optional cors rules for blob, shares and queues ([#65](https://github.com/CloudNationHQ/terraform-azure-sa/issues/65)) ([163033b](https://github.com/CloudNationHQ/terraform-azure-sa/commit/163033be9ec28b813855b89e3c0f50866da6a677))

## [0.16.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.15.0...v0.16.0) (2024-04-22)


### Features

* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#59](https://github.com/CloudNationHQ/terraform-azure-sa/issues/59)) ([0fdca5c](https://github.com/CloudNationHQ/terraform-azure-sa/commit/0fdca5cb39f3c4aaa7c2af69e281bc57fd5008d8))
* **deps:** bump golang.org/x/net from 0.19.0 to 0.23.0 in /tests ([#60](https://github.com/CloudNationHQ/terraform-azure-sa/issues/60)) ([de1458e](https://github.com/CloudNationHQ/terraform-azure-sa/commit/de1458e317df6875a6e8c3d1d7db49d5fca9ad27))
* make use of table driven tests ([#57](https://github.com/CloudNationHQ/terraform-azure-sa/issues/57)) ([2f3b431](https://github.com/CloudNationHQ/terraform-azure-sa/commit/2f3b431d74e8e05d13477d612b1aaaec97321cb6))

## [0.15.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.14.0...v0.15.0) (2024-04-12)


### Features

* added extended testing for all subresources and refactored code to be more idiomatic ([#55](https://github.com/CloudNationHQ/terraform-azure-sa/issues/55)) ([9e0ab46](https://github.com/CloudNationHQ/terraform-azure-sa/commit/9e0ab46e51363afbb8ec017e34818b8650f824e5))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#54](https://github.com/CloudNationHQ/terraform-azure-sa/issues/54)) ([22d6d8f](https://github.com/CloudNationHQ/terraform-azure-sa/commit/22d6d8fde5570117daccfc73b5ec4c1e66a0b268))

## [0.14.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.13.0...v0.14.0) (2024-03-19)


### Features

* refactored extended tests for modularity and readability and added container verifications ([#52](https://github.com/CloudNationHQ/terraform-azure-sa/issues/52)) ([5c9a15e](https://github.com/CloudNationHQ/terraform-azure-sa/commit/5c9a15ebb2baae1bff2d248deb0887f4f6a5c986))

## [0.13.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.12.0...v0.13.0) (2024-03-15)


### Features

* small correction in documentation private endpoint usage ([#51](https://github.com/CloudNationHQ/terraform-azure-sa/issues/51)) ([ccf48a9](https://github.com/CloudNationHQ/terraform-azure-sa/commit/ccf48a91f0b79135d20bd4f59472c20de0db2b71))
* update documentation ([#49](https://github.com/CloudNationHQ/terraform-azure-sa/issues/49)) ([6edf53b](https://github.com/CloudNationHQ/terraform-azure-sa/commit/6edf53b6c42e4755e784bde829b072a8edd49c6e))

## [0.12.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.11.0...v0.12.0) (2024-03-14)


### Features

* **deps:** bump google.golang.org/protobuf in /tests ([#46](https://github.com/CloudNationHQ/terraform-azure-sa/issues/46)) ([3eee708](https://github.com/CloudNationHQ/terraform-azure-sa/commit/3eee708ae300c759b8e6cd03adb54a0f0187fe7a))
* small refactor private endpoints ([#47](https://github.com/CloudNationHQ/terraform-azure-sa/issues/47)) ([f9a612e](https://github.com/CloudNationHQ/terraform-azure-sa/commit/f9a612eec245033b91e6ba40b4564638f26b166c))

## [0.11.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.10.0...v0.11.0) (2024-03-12)


### Features

* add customer managed key support ([#44](https://github.com/CloudNationHQ/terraform-azure-sa/issues/44)) ([33400c2](https://github.com/CloudNationHQ/terraform-azure-sa/commit/33400c21778e2c89e9f3ca925be4ff1b1f555383))

## [0.10.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.9.1...v0.10.0) (2024-03-08)


### Features

* add conditional expressions to allow some global properties and updated documentation ([#42](https://github.com/CloudNationHQ/terraform-azure-sa/issues/42)) ([2f72ed2](https://github.com/CloudNationHQ/terraform-azure-sa/commit/2f72ed23da466ea0cc782d4c1ba4c2a048bf61cd))
* **deps:** bump github.com/stretchr/testify in /tests ([#40](https://github.com/CloudNationHQ/terraform-azure-sa/issues/40)) ([5324e37](https://github.com/CloudNationHQ/terraform-azure-sa/commit/5324e37981559e9351dfd031fe40349a886b1ce3))

## [0.9.1](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.9.0...v0.9.1) (2024-03-01)


### Bug Fixes

* fix queue, blob and share properties to be fully optional ([#38](https://github.com/CloudNationHQ/terraform-azure-sa/issues/38)) ([97224f5](https://github.com/CloudNationHQ/terraform-azure-sa/commit/97224f5ee2eda8686294930df5166e94f70f937c))

## [0.9.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.8.1...v0.9.0) (2024-02-29)


### Features

* optimized dynamic identity blocks ([#36](https://github.com/CloudNationHQ/terraform-azure-sa/issues/36)) ([1726abf](https://github.com/CloudNationHQ/terraform-azure-sa/commit/1726abffcf7e864f9353eb62c712b9817ce4717c))

## [0.8.1](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.8.0...v0.8.1) (2024-02-28)


### Bug Fixes

* fix typos queue properties ([#34](https://github.com/CloudNationHQ/terraform-azure-sa/issues/34)) ([2434e70](https://github.com/CloudNationHQ/terraform-azure-sa/commit/2434e70de6e115ec9d44a0e7a1b1175c8d0d4c0f))

## [0.8.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.7.0...v0.8.0) (2024-02-28)


### Features

* improved alignment for several properties and added some missing ones ([#32](https://github.com/CloudNationHQ/terraform-azure-sa/issues/32)) ([fb7a1a9](https://github.com/CloudNationHQ/terraform-azure-sa/commit/fb7a1a96063428bf79c26b45c1bed1da24650a2f))

## [0.7.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.6.0...v0.7.0) (2024-02-05)


### Features

* change default value cross tenant replication to false ([#23](https://github.com/CloudNationHQ/terraform-azure-sa/issues/23)) ([1dadbfd](https://github.com/CloudNationHQ/terraform-azure-sa/commit/1dadbfdcbf91794e5dfa8a7751ef741abc5ac16a))
* change defaults bypass property network rules ([#30](https://github.com/CloudNationHQ/terraform-azure-sa/issues/30)) ([f4147ba](https://github.com/CloudNationHQ/terraform-azure-sa/commit/f4147bace32f39dbffe546a230926f5cced72ea8))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#26](https://github.com/CloudNationHQ/terraform-azure-sa/issues/26)) ([9be36c1](https://github.com/CloudNationHQ/terraform-azure-sa/commit/9be36c1bdedc9c3a2121a251bfdb5ee20957be81))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#27](https://github.com/CloudNationHQ/terraform-azure-sa/issues/27)) ([b739c64](https://github.com/CloudNationHQ/terraform-azure-sa/commit/b739c6422b99d9846b94dff38c16df1586962f5e))
* small refactor workflows ([#25](https://github.com/CloudNationHQ/terraform-azure-sa/issues/25)) ([7d27e7f](https://github.com/CloudNationHQ/terraform-azure-sa/commit/7d27e7fff07d8a1909118dcdf577a982bec4d8e9))


### Bug Fixes

* make blob properties fully optional again ([#31](https://github.com/CloudNationHQ/terraform-azure-sa/issues/31)) ([340a882](https://github.com/CloudNationHQ/terraform-azure-sa/commit/340a882337406a99e97d471d7a1b0201a088d871))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.5.0...v0.6.0) (2024-01-16)


### Features

* add several missing properties ([#19](https://github.com/CloudNationHQ/terraform-azure-sa/issues/19)) ([b0b9597](https://github.com/CloudNationHQ/terraform-azure-sa/commit/b0b95972c58ad15c00c6bbc74ad1500dc2b8f0fa))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#18](https://github.com/CloudNationHQ/terraform-azure-sa/issues/18)) ([758d745](https://github.com/CloudNationHQ/terraform-azure-sa/commit/758d745d3e9ccffb35b122484fa16471e7024e38))
* retention and restore policies are fully optional now ([#20](https://github.com/CloudNationHQ/terraform-azure-sa/issues/20)) ([1e94788](https://github.com/CloudNationHQ/terraform-azure-sa/commit/1e947883d294b875ed9d26f43c3abc55989542d5))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.4.0...v0.5.0) (2024-01-12)


### Features

* Improved name property flexibility with manual and default options ([#16](https://github.com/CloudNationHQ/terraform-azure-sa/issues/16)) ([c101a0f](https://github.com/CloudNationHQ/terraform-azure-sa/commit/c101a0fc712df97fcd03584e9a32eef8a2e4c5c4))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.3.0...v0.4.0) (2023-12-19)


### Features

* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage ([#10](https://github.com/CloudNationHQ/terraform-azure-sa/issues/10)) ([b393565](https://github.com/CloudNationHQ/terraform-azure-sa/commit/b3935652c8ec5cb203f7c8c78e521e44d0ba54fe))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#11](https://github.com/CloudNationHQ/terraform-azure-sa/issues/11)) ([cf34c3b](https://github.com/CloudNationHQ/terraform-azure-sa/commit/cf34c3b768257863fb0eea75746456d115e0454a))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#7](https://github.com/CloudNationHQ/terraform-azure-sa/issues/7)) ([101829f](https://github.com/CloudNationHQ/terraform-azure-sa/commit/101829fc4a8a347d91f54b7a4425f57a25084dde))
* **deps:** bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#12](https://github.com/CloudNationHQ/terraform-azure-sa/issues/12)) ([7b07c5a](https://github.com/CloudNationHQ/terraform-azure-sa/commit/7b07c5aaf08d2dbf7442f6d8f6556ebc9d611d4f))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.2.0...v0.3.0) (2023-11-07)


### Features

* add support for network rules ([#5](https://github.com/CloudNationHQ/terraform-azure-sa/issues/5)) ([9b63cde](https://github.com/CloudNationHQ/terraform-azure-sa/commit/9b63cde7723d26082525eb1027735582b95f9701))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.1.0...v0.2.0) (2023-11-03)


### Features

* fix module source references in examples ([#3](https://github.com/CloudNationHQ/terraform-azure-sa/issues/3)) ([fabd090](https://github.com/CloudNationHQ/terraform-azure-sa/commit/fabd0902a537d0d40d04cabb0c5f65769cb04046))

## 0.1.0 (2023-11-02)


### Features

* add initial resources ([#1](https://github.com/CloudNationHQ/terraform-azure-sa/issues/1)) ([d983841](https://github.com/CloudNationHQ/terraform-azure-sa/commit/d98384188d09f4710092b6f23e977f8d3f3c1f49))
