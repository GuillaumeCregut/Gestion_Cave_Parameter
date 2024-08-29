object FPpale: TFPpale
  Left = 0
  Top = 0
  Caption = 'Programmation du coffret'
  ClientHeight = 543
  ClientWidth = 976
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 976
    Height = 517
    ActivePage = TSProgrammation
    Align = alClient
    TabOrder = 0
    object TSConfig: TTabSheet
      Caption = 'Configuration'
      object GBParamsCom: TGroupBox
        Left = 24
        Top = 24
        Width = 529
        Height = 233
        Caption = 'Param'#232'tres de communication'
        TabOrder = 0
        object Label1: TLabel
          Left = 24
          Top = 40
          Width = 22
          Height = 15
          Caption = 'Port'
        end
        object Label2: TLabel
          Left = 24
          Top = 72
          Width = 36
          Height = 15
          Caption = 'Vitesse'
        end
        object Label3: TLabel
          Left = 24
          Top = 104
          Width = 30
          Height = 15
          Caption = 'Parit'#233
        end
        object Label4: TLabel
          Left = 24
          Top = 144
          Width = 82
          Height = 15
          Caption = 'Nombre de bits'
        end
        object Label5: TLabel
          Left = 24
          Top = 176
          Width = 24
          Height = 15
          Caption = 'Stop'
        end
        object CBPort: TComboBox
          Left = 64
          Top = 37
          Width = 145
          Height = 23
          TabOrder = 0
        end
        object CBBaudRate: TComboBox
          Left = 66
          Top = 66
          Width = 145
          Height = 23
          ItemIndex = 1
          TabOrder = 1
          Text = '9600'
          Items.Strings = (
            '4800'
            '9600'
            '19200')
        end
        object CBParity: TComboBox
          Left = 66
          Top = 101
          Width = 145
          Height = 23
          ItemIndex = 2
          TabOrder = 2
          Text = 'Sans'
          Items.Strings = (
            'Paire'
            'Impaire'
            'Sans')
        end
        object CBDatas: TComboBox
          Left = 120
          Top = 141
          Width = 145
          Height = 23
          ItemIndex = 3
          TabOrder = 3
          Text = '7'
          Items.Strings = (
            '4'
            '5'
            '6'
            '7'
            '8')
        end
        object CBStop: TComboBox
          Left = 66
          Top = 176
          Width = 145
          Height = 23
          ItemIndex = 0
          TabOrder = 4
          Text = '1'
          Items.Strings = (
            '1'
            '2')
        end
        object BValidateParam: TButton
          Left = 384
          Top = 192
          Width = 75
          Height = 25
          Caption = 'Valider'
          TabOrder = 5
          OnClick = BValidateParamClick
        end
      end
    end
    object TSProgrammation: TTabSheet
      Caption = 'Programmation'
      ImageIndex = 1
      object GBProg: TGroupBox
        Left = 3
        Top = 3
        Width = 473
        Height = 318
        Caption = 'R'#233'seau'
        TabOrder = 0
        object Label6: TLabel
          Left = 16
          Top = 24
          Width = 112
          Height = 15
          Caption = 'Identifiant Wifi (SSID)'
        end
        object Label7: TLabel
          Left = 16
          Top = 64
          Width = 41
          Height = 15
          Caption = 'Cl'#233' Wifi'
        end
        object ESsid: TEdit
          Left = 144
          Top = 21
          Width = 177
          Height = 23
          TabOrder = 0
          OnChange = ESsidChange
        end
        object EWifiPass: TEdit
          Left = 144
          Top = 61
          Width = 281
          Height = 23
          TabOrder = 1
          OnChange = EWifiPassChange
        end
        object CBDHCP: TCheckBox
          Left = 16
          Top = 96
          Width = 57
          Height = 17
          Caption = 'DHCP'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = CBDHCPClick
        end
        object PNetwork: TPanel
          Left = 16
          Top = 119
          Width = 409
          Height = 170
          BevelInner = bvLowered
          ParentBackground = False
          TabOrder = 3
          object Label8: TLabel
            Left = 16
            Top = 8
            Width = 54
            Height = 15
            Caption = 'Adresse IP'
          end
          object Label9: TLabel
            Left = 16
            Top = 45
            Width = 122
            Height = 15
            Caption = 'Masque de sous r'#233'seau'
          end
          object Label10: TLabel
            Left = 16
            Top = 75
            Width = 51
            Height = 15
            Caption = 'Passerelle'
          end
          object Label11: TLabel
            Left = 16
            Top = 104
            Width = 32
            Height = 15
            Caption = 'DNS 1'
          end
          object Label12: TLabel
            Left = 16
            Top = 141
            Width = 32
            Height = 15
            Caption = 'DNS 2'
          end
          object MEIpAdress: TMaskEdit
            Left = 88
            Top = 8
            Width = 137
            Height = 21
            EditMask = '!099.099.099.099;1;'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier'
            Font.Style = []
            MaxLength = 15
            ParentFont = False
            TabOrder = 0
            Text = '   .   .   .   '
            OnExit = MEIpAdressExit
          end
          object MESubnet: TMaskEdit
            Left = 144
            Top = 43
            Width = 145
            Height = 21
            EditMask = '!099.099.099.099;1;'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier'
            Font.Style = []
            MaxLength = 15
            ParentFont = False
            TabOrder = 1
            Text = '   .   .   .   '
            OnExit = MESubnetExit
          end
          object MEGateway: TMaskEdit
            Left = 144
            Top = 72
            Width = 145
            Height = 21
            EditMask = '!099.099.099.099;1;'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier'
            Font.Style = []
            MaxLength = 15
            ParentFont = False
            TabOrder = 2
            Text = '   .   .   .   '
            OnExit = MEGatewayExit
          end
          object MEDns1: TMaskEdit
            Left = 144
            Top = 101
            Width = 145
            Height = 21
            EditMask = '!099.099.099.099;1;'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier'
            Font.Style = []
            MaxLength = 15
            ParentFont = False
            TabOrder = 3
            Text = '   .   .   .   '
            OnExit = MEDns1Exit
          end
          object MEDns2: TMaskEdit
            Left = 144
            Top = 136
            Width = 145
            Height = 21
            EditMask = '!099.099.099.099;1;'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier'
            Font.Style = []
            MaxLength = 15
            ParentFont = False
            TabOrder = 4
            Text = '   .   .   .   '
            OnExit = MEDns2Exit
          end
        end
      end
      object GBAppli: TGroupBox
        Left = 3
        Top = 343
        Width = 473
        Height = 130
        Caption = 'Application'
        TabOrder = 1
        object Label13: TLabel
          Left = 16
          Top = 24
          Width = 99
          Height = 15
          Caption = 'Adresse du serveur'
        end
        object Label14: TLabel
          Left = 16
          Top = 52
          Width = 89
          Height = 15
          Caption = 'Cl'#233' d'#39'application'
        end
        object Label15: TLabel
          Left = 17
          Top = 96
          Width = 160
          Height = 15
          Caption = 'P'#233'riode de mesure (en heures)'
        end
        object MEIpServer: TMaskEdit
          Left = 135
          Top = 16
          Width = 141
          Height = 21
          EditMask = '!099.099.099.099;1;'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier'
          Font.Style = []
          MaxLength = 15
          ParentFont = False
          TabOrder = 0
          Text = '   .   .   .   '
          OnExit = MEIpServerExit
        end
        object EAppKey: TEdit
          Left = 135
          Top = 53
          Width = 186
          Height = 23
          TabOrder = 1
        end
        object EPeriod: TEdit
          Left = 196
          Top = 90
          Width = 59
          Height = 23
          ReadOnly = True
          TabOrder = 2
          Text = '1'
        end
        object SpinButton1: TSpinButton
          Left = 256
          Top = 88
          Width = 20
          Height = 25
          DownGlyph.Data = {
            0E010000424D0E01000000000000360000002800000009000000060000000100
            200000000000D800000000000000000000000000000000000000008080000080
            8000008080000080800000808000008080000080800000808000008080000080
            8000008080000080800000808000000000000080800000808000008080000080
            8000008080000080800000808000000000000000000000000000008080000080
            8000008080000080800000808000000000000000000000000000000000000000
            0000008080000080800000808000000000000000000000000000000000000000
            0000000000000000000000808000008080000080800000808000008080000080
            800000808000008080000080800000808000}
          TabOrder = 3
          UpGlyph.Data = {
            0E010000424D0E01000000000000360000002800000009000000060000000100
            200000000000D800000000000000000000000000000000000000008080000080
            8000008080000080800000808000008080000080800000808000008080000080
            8000000000000000000000000000000000000000000000000000000000000080
            8000008080000080800000000000000000000000000000000000000000000080
            8000008080000080800000808000008080000000000000000000000000000080
            8000008080000080800000808000008080000080800000808000000000000080
            8000008080000080800000808000008080000080800000808000008080000080
            800000808000008080000080800000808000}
          OnDownClick = SpinButton1DownClick
          OnUpClick = SpinButton1UpClick
        end
      end
      object BReadProd: TButton
        Left = 520
        Top = 63
        Width = 75
        Height = 25
        Caption = 'Lecture'
        TabOrder = 2
        OnClick = BReadProgClick
      end
      object BWriteProg: TButton
        Left = 520
        Top = 112
        Width = 75
        Height = 25
        Caption = 'Ecrire'
        TabOrder = 3
        OnClick = BWriteProgClick
      end
      object Memo1: TMemo
        Left = 736
        Top = 35
        Width = 185
        Height = 347
        TabOrder = 4
      end
    end
  end
  object SBStatus: TStatusBar
    Left = 0
    Top = 517
    Width = 976
    Height = 26
    Panels = <
      item
        Width = 300
      end
      item
        Alignment = taCenter
        Text = '(c)2024 Editiel98'
        Width = 50
      end>
  end
end
