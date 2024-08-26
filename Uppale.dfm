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
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 441
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
      end
    end
    object TSProgrammation: TTabSheet
      Caption = 'Programmation'
      ImageIndex = 1
    end
  end
end
