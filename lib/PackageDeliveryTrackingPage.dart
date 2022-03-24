import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';


// import '../widget.dart';

const kTileHeight = 50.0;




class PackageDeliveryTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final data = _data(index + 1);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(height: 1.0),
            _DeliveryProcesses(processes: data.deliveryProcesses),
            Divider(height: 1.0),
          ],
        );
      },
    );
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    @required this.messages,
  });

  final List<_DeliveryMessage> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
            thickness: 1.0,
          ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
            size: 10.0,
            position: 0.5,
          ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
          !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Center(
            child: Connector.solidLine(),
          ),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(messages[index - 1].toString()),
            );
          },
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key key, @required this.processes})
      : assert(processes != null),
        super(key: key);

  final List<_DeliveryProcess> processes;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              if (processes[index].isCompleted) return null;

              return Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].name,
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 18.0,
                      ),
                    ),
                    _InnerTimeline(messages: processes[index].messages),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].isCompleted) {
                return DotIndicator(
                  color: Color(0xff66c97f),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
              } else {
                return OutlinedDotIndicator(
                  borderWidth: 2.5,
                );
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].isCompleted ? Color(0xff66c97f) : null,
            ),
          ),
        ),
      ),
    );
  }
}

_OrderInfo _data(int id) => _OrderInfo(
  deliveryProcesses: [
    _DeliveryProcess(
      'FLIGHT 6E 2341',
      '7:00AM',
      'Package Process',

      messages: [
        _DeliveryMessage('8:30am', 'Package received by driver'),
        _DeliveryMessage('11:30am', 'Reached halfway mark'),
      ],
    ),
    _DeliveryProcess(
      '7:00AM',
      'Package Process',
      'FLIGHT 6E 2341',
      messages: [
        _DeliveryMessage('8:30am', 'Package received by driver'),
        _DeliveryMessage('11:30am', 'Reached halfway mark'),
      ],
    ),
    _DeliveryProcess(
      '7:00AM', 'Package Process', 'FLIGHT 6E 2341',
      messages: [
        _DeliveryMessage('8:30am', 'Package received by driver'),
        _DeliveryMessage('11:30am', 'Reached halfway mark'),
      ],
    ),
    _DeliveryProcess(
      '7:00AM',
      'Package Process',
      'FLIGHT 6E 2341',
      messages: [
        _DeliveryMessage('8:30am', 'Package received by driver'),
        _DeliveryMessage('11:30am', 'Reached halfway mark'),
      ],
    ),
    _DeliveryProcess(
      '7:00AM',
      'In Transit',
      'FLIGHT 6E 2341',
      messages: [
        _DeliveryMessage('13:00pm', 'Driver arrived at destination'),
        _DeliveryMessage('11:35am', 'Package delivered by m.vassiliades'),
      ],
    ),
    _DeliveryProcess.complete(),
  ],
);

class _OrderInfo {
  const _OrderInfo({

    @required this.deliveryProcesses,
  });


  final List<_DeliveryProcess> deliveryProcesses;
}



class _DeliveryProcess {
  const _DeliveryProcess(
      this.timeStamp,
      this.address,
      this.name, {
        this.messages = const [],
      });

  const _DeliveryProcess.complete()
      : this.name = 'Done',
        this.address = '',
        this.timeStamp = '',
        this.messages = const [];

  final String name;
  final String timeStamp;
  final String address;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$createdAt $message';
  }
}

