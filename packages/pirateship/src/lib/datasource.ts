import { BazaarvoiceDataSource } from '@brandingbrand/fsbazaarvoice';
import { env } from '@brandingbrand/fsapp';
const { dataSourceConfigs } = env;

export interface DataSourceConfig {
  type: 'bbplatform' | 'commercecloud' | 'shopify';
  categoryFormat: 'grid' | 'list';
  apiConfig: any;
}

/*
import BBPlatformDataSource from './BBPlatformDataSource';
export const dataSource = new BBPlatformDataSource(dataSourceConfigs.bbPlatform.apiConfig.apiHost);
export const dataSourceConfig: DataSourceConfig = dataSourceConfigs.bbPlatform;
*/

import { CommerceCloudDataSource } from '@brandingbrand/fssalesforce';
import FSNetwork from '@brandingbrand/fsnetwork';
import { commerceCloudMiddleware } from './commerceCloudMiddleware';

const config: any = dataSourceConfigs.commerceCloud.apiConfig;
config.middleware = commerceCloudMiddleware;

if (config.networkClient) {
  config.networkClient = new FSNetwork(config.networkClient);
}

export const dataSource = new CommerceCloudDataSource(config);
export const dataSourceConfig: DataSourceConfig = dataSourceConfigs.commerceCloud;

/*
import { ShopifyDataSource } from '@brandingbrand/fsshopify';
const config: any = dataSourceConfigs.shopify.apiConfig;
export const dataSource = new ShopifyDataSource(config);
export const dataSourceConfig = dataSourceConfigs.shopify;
*/

export const bvDataSource = new BazaarvoiceDataSource(dataSourceConfigs.bazaarVoice);
