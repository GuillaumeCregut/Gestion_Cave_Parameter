object FPpale: TFPpale
  Left = 0
  Top = 0
  Caption = 'Programmation du coffret'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 415
    ActivePage = TSConfig
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
            '1.5'
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
    end
  end
  object SBStatus: TStatusBar
    Left = 0
    Top = 415
    Width = 624
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
    ExplicitLeft = 8
    ExplicitTop = 417
  end
end
