import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.2

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controllers           1.0
import QGroundControl.SettingsManager       1.0



Rectangle {

    id:                 _root

    property Fact _savePath:                            QGroundControl.settingsManager.appSettings.savePath
    property Fact _appFontPointSize:                    QGroundControl.settingsManager.appSettings.appFontPointSize
    property Fact _userBrandImageIndoor:                QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor
    property Fact _userBrandImageOutdoor:               QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor
    property Fact _virtualJoystick:                     QGroundControl.settingsManager.appSettings.virtualJoystick
    property Fact _virtualJoystickAutoCenterThrottle:   QGroundControl.settingsManager.appSettings.virtualJoystickAutoCenterThrottle

    property real   _labelWidth:                ScreenTools.defaultFontPixelWidth * 20
    property real   _comboFieldWidth:           ScreenTools.defaultFontPixelWidth * 30
    property real   _valueFieldWidth:           ScreenTools.defaultFontPixelWidth * 10
    property string _mapProvider:               QGroundControl.settingsManager.flightMapSettings.mapProvider.value
    property string _mapType:                   QGroundControl.settingsManager.flightMapSettings.mapType.value
    property Fact   _followTarget:              QGroundControl.settingsManager.appSettings.followTarget
    property real   _panelWidth:                _root.width * _internalWidthRatio
    property real   _margins:                   ScreenTools.defaultFontPixelWidth
    property var    _planViewSettings:          QGroundControl.settingsManager.planViewSettings
    property var    _flyViewSettings:           QGroundControl.settingsManager.flyViewSettings
    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings
    property string _videoSource:               _videoSettings.videoSource.value
    property bool   _isGst:                     QGroundControl.videoManager.isGStreamer
    property bool   _isUDP264:                  _isGst && _videoSource === _videoSettings.udp264VideoSource
    property bool   _isUDP265:                  _isGst && _videoSource === _videoSettings.udp265VideoSource
    property bool   _isRTSP:                    _isGst && _videoSource === _videoSettings.rtspVideoSource
    property bool   _isTCP:                     _isGst && _videoSource === _videoSettings.tcpVideoSource
    property bool   _isMPEGTS:                  _isGst && _videoSource === _videoSettings.mpegtsVideoSource
    property bool   _videoAutoStreamConfig:     QGroundControl.videoManager.autoStreamConfigured
    property bool   _showSaveVideoSettings:     _isGst || _videoAutoStreamConfig
    property bool   _disableAllDataPersistence: QGroundControl.settingsManager.appSettings.disableAllPersistence.rawValue

    property string gpsDisabled: "Disabled"
    property string gpsUdpPort:  "UDP Port"

    readonly property real _internalWidthRatio: 0.8



    Layout.preferredHeight: flyViewCol.height + (_margins * 2)
    Layout.preferredWidth:  flyViewCol.width + (_margins * 2)
    color:                  qgcPal.windowShade
    visible:                flyViewSectionLabel.visible
    Layout.fillWidth:       true

    ColumnLayout {
        id:                         flyViewCol
        anchors.margins:            _margins
        anchors.top:                parent.top
        anchors.horizontalCenter:   parent.horizontalCenter
        spacing:                    _margins

        FactCheckBox {
            id:             useCheckList
            text:           qsTr("Use Preflight Checklist")
            fact:           _useChecklist
            visible:        _useChecklist.visible && QGroundControl.corePlugin.options.preFlightChecklistUrl.toString().length

            property Fact _useChecklist: QGroundControl.settingsManager.appSettings.useChecklist
        }

        FactCheckBox {
            text:           qsTr("Enforce Preflight Checklist")
            fact:           _enforceChecklist
            enabled:        QGroundControl.settingsManager.appSettings.useChecklist.value
            visible:        useCheckList.visible && _enforceChecklist.visible && QGroundControl.corePlugin.options.preFlightChecklistUrl.toString().length

            property Fact _enforceChecklist: QGroundControl.settingsManager.appSettings.enforceChecklist
        }

        FactCheckBox {
            text:       qsTr("Keep Map Centered On Vehicle")
            fact:       _keepMapCenteredOnVehicle
            visible:    _keepMapCenteredOnVehicle.visible

            property Fact _keepMapCenteredOnVehicle: QGroundControl.settingsManager.flyViewSettings.keepMapCenteredOnVehicle
        }

        FactCheckBox {
            text:       qsTr("Show Telemetry Log Replay Status Bar")
            fact:       _showLogReplayStatusBar
            visible:    _showLogReplayStatusBar.visible

            property Fact _showLogReplayStatusBar: QGroundControl.settingsManager.flyViewSettings.showLogReplayStatusBar
        }

        RowLayout {
            spacing: ScreenTools.defaultFontPixelWidth

            FactCheckBox {
                text:       qsTr("Virtual Joystick")
                visible:    _virtualJoystick.visible
                fact:       _virtualJoystick
            }

            FactCheckBox {
                text:       qsTr("Auto-Center Throttle")
                visible:    _virtualJoystickAutoCenterThrottle.visible
                enabled:    _virtualJoystick.rawValue
                fact:       _virtualJoystickAutoCenterThrottle
            }
        }

        FactCheckBox {
            text:       qsTr("Use Vertical Instrument Panel")
            visible:    _alternateInstrumentPanel.visible
            fact:       _alternateInstrumentPanel

            property Fact _alternateInstrumentPanel: QGroundControl.settingsManager.flyViewSettings.alternateInstrumentPanel
        }

        FactCheckBox {
            text:       qsTr("Show additional heading indicators on Compass")
            visible:    _showAdditionalIndicatorsCompass.visible
            fact:       _showAdditionalIndicatorsCompass

            property Fact _showAdditionalIndicatorsCompass: QGroundControl.settingsManager.flyViewSettings.showAdditionalIndicatorsCompass
        }

        FactCheckBox {
            text:       qsTr("Lock Compass Nose-Up")
            visible:    _lockNoseUpCompass.visible
            fact:       _lockNoseUpCompass

            property Fact _lockNoseUpCompass: QGroundControl.settingsManager.flyViewSettings.lockNoseUpCompass
        }

        FactCheckBox {
            text:       qsTr("Show simple camera controls (DIGICAM_CONTROL)")
            visible:    _showDumbCameraControl.visible
            fact:       _showDumbCameraControl

            property Fact _showDumbCameraControl: QGroundControl.settingsManager.flyViewSettings.showSimpleCameraControl
        }

        GridLayout {
            columns: 2

            QGCLabel {
                text:               qsTr("Guided Command Settings")
                Layout.columnSpan:  2
                Layout.alignment:   Qt.AlignHCenter
            }

            QGCLabel {
                text:       qsTr("Minimum Altitude")
                visible:    guidedMinAltField.visible
            }
            FactTextField {
                id:                     guidedMinAltField
                Layout.preferredWidth:  _valueFieldWidth
                visible:                fact.visible
                fact:                   _flyViewSettings.guidedMinimumAltitude
            }

            QGCLabel {
                text:       qsTr("Maximum Altitude")
                visible:    guidedMaxAltField.visible
            }
            FactTextField {
                id:                     guidedMaxAltField
                Layout.preferredWidth:  _valueFieldWidth
                visible:                fact.visible
                fact:                   _flyViewSettings.guidedMaximumAltitude
            }

            QGCLabel {
                text:       qsTr("Go To Location Max Distance")
                visible:    maxGotoDistanceField.visible
            }
            FactTextField {
                id:                     maxGotoDistanceField
                Layout.preferredWidth:  _valueFieldWidth
                visible:                fact.visible
                fact:                  _flyViewSettings.maxGoToLocationDistance
            }
        }

        GridLayout {
            id:         videoGrid
            columns:    2
            visible:    _videoSettings.visible

            QGCLabel {
                text:               qsTr("Video Settings")
                Layout.columnSpan:  2
                Layout.alignment:   Qt.AlignHCenter
            }

            QGCLabel {
                id:         videoSourceLabel
                text:       qsTr("Source")
                visible:    !_videoAutoStreamConfig && _videoSettings.videoSource.visible
            }
            FactComboBox {
                id:                     videoSource
                Layout.preferredWidth:  _comboFieldWidth
                indexModel:             false
                fact:                   _videoSettings.videoSource
                visible:                videoSourceLabel.visible
            }

            QGCLabel {
                id:         udpPortLabel
                text:       qsTr("UDP Port")
                visible:    !_videoAutoStreamConfig && (_isUDP264 || _isUDP265 || _isMPEGTS) && _videoSettings.udpPort.visible
            }
            FactTextField {
                Layout.preferredWidth:  _comboFieldWidth
                fact:                   _videoSettings.udpPort
                visible:                udpPortLabel.visible
            }

            QGCLabel {
                id:         rtspUrlLabel
                text:       qsTr("RTSP URL")
                visible:    !_videoAutoStreamConfig && _isRTSP && _videoSettings.rtspUrl.visible
            }
            FactTextField {
                Layout.preferredWidth:  _comboFieldWidth
                fact:                   _videoSettings.rtspUrl
                visible:                rtspUrlLabel.visible
            }

            QGCLabel {
                id:         tcpUrlLabel
                text:       qsTr("TCP URL")
                visible:    !_videoAutoStreamConfig && _isTCP && _videoSettings.tcpUrl.visible
            }
            FactTextField {
                Layout.preferredWidth:  _comboFieldWidth
                fact:                   _videoSettings.tcpUrl
                visible:                tcpUrlLabel.visible
            }

            QGCLabel {
                text:                   qsTr("Aspect Ratio")
                visible:                !_videoAutoStreamConfig && _isGst && _videoSettings.aspectRatio.visible
            }
            FactTextField {
                Layout.preferredWidth:  _comboFieldWidth
                fact:                   _videoSettings.aspectRatio
                visible:                !_videoAutoStreamConfig && _isGst && _videoSettings.aspectRatio.visible
            }

            QGCLabel {
                id:         videoFileFormatLabel
                text:       qsTr("File Format")
                visible:    _showSaveVideoSettings && _videoSettings.recordingFormat.visible
            }
            FactComboBox {
                Layout.preferredWidth:  _comboFieldWidth
                fact:                   _videoSettings.recordingFormat
                visible:                videoFileFormatLabel.visible
            }

            QGCLabel {
                id:         maxSavedVideoStorageLabel
                text:       qsTr("Max Storage Usage")
                visible:    _showSaveVideoSettings && _videoSettings.maxVideoSize.visible && _videoSettings.enableStorageLimit.value
            }
            FactTextField {
                Layout.preferredWidth:  _comboFieldWidth
                fact:                   _videoSettings.maxVideoSize
                visible:                _showSaveVideoSettings && _videoSettings.enableStorageLimit.value && maxSavedVideoStorageLabel.visible
            }

            QGCLabel {
                id:         videoDecodeLabel
                text:       qsTr("Video decode priority")
                visible:    forceVideoDecoderComboBox.visible
            }
            FactComboBox {
                id:                     forceVideoDecoderComboBox
                Layout.preferredWidth:  _comboFieldWidth
                fact:                   _videoSettings.forceVideoDecoder
                visible:                fact.visible
                indexModel:             false
            }

            Item { width: 1; height: 1}
            FactCheckBox {
                text:       qsTr("Disable When Disarmed")
                fact:       _videoSettings.disableWhenDisarmed
                visible:    !_videoAutoStreamConfig && _isGst && fact.visible
            }

            Item { width: 1; height: 1}
            FactCheckBox {
                text:       qsTr("Low Latency Mode")
                fact:       _videoSettings.lowLatencyMode
                visible:    !_videoAutoStreamConfig && _isGst && fact.visible
            }

            Item { width: 1; height: 1}
            FactCheckBox {
                text:       qsTr("Auto-Delete Saved Recordings")
                fact:       _videoSettings.enableStorageLimit
                visible:    _showSaveVideoSettings && fact.visible
            }
        }
    }
}









