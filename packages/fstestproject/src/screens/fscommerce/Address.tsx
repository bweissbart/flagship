import React, { Component } from 'react';
import { ScrollView } from 'react-native';
import { goToNavPush } from '../../lib/navigation';
import Row from '../../components/Row';

export default class Home extends Component<any, any> {
  goTo = (screen: any, title: any, backButtonTitle: any) => () => {
    goToNavPush('fscommerce', this.props.componentId, screen, title, backButtonTitle);
  }

  render(): JSX.Element {
    return (
      <ScrollView style={{ flex: 1 }}>
        <Row
          text='UPSAddressExample'
          onPress={this.goTo('UPSAddressExample', 'UPSAddressExample', 'Back')}
        />
      </ScrollView>
    );
  }
}
