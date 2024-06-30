<div align="center">
<h1>JSON_GEN_FORM</h1>

English · [中文](./README.md)

![](./screenshots/json_gen_form.gif)

</div>

## General Parameters

Except for `group`, `row`, and `col`, all types have the following general parameters. All types have `extra`.

| Field       | Description      | Type    | Default Value | Required |
| ----------- | ---------------- | ------- | ------------- | -------- |
| type        | Type             | String  | ''            | true     |
| field       | Field Name       | String  | ''            | true     |
| label       | Label            | String  | -             | -        |
| hiddenLabel | Hidden Label     | bool    | false         | -        |
| value       | Default Value    | dynamic | -             | -        |
| disabled    | Disabled         | bool    | false         | -        |
| readonly    | Read-Only        | bool    | false         | -        |
| rules       | Validation Rules | List    | []            | -        |
| extra       | Extra Params     | dynamic |               | -        |

## Form Types

### group

| Field       | Description  | Type      | Default Value | Required |
| ----------- | ------------ | --------- | ------------- | -------- |
| type        | Type         | String    | 'group'       | true     |
| field       | Field Name   | String    | ''            | -        |
| label       | Label        | String    | ''            | -        |
| hiddenLabel | Hidden Label | bool      | ''            | -        |
| children    | Sub-Forms    | List<Map> | []            | -        |

### text

| Field          | Description | Type   | Default Value | Required |
| -------------- | ----------- | ------ | ------------- | -------- |
| type           | Type        | String | 'text'        | true     |
| placeholder    | Placeholder | String | -             | -        |
| General Params | -           | -      | -             | -        |

### password

| Field          | Description | Type   | Default Value | Required |
| -------------- | ----------- | ------ | ------------- | -------- |
| type           | Type        | String | 'password'    | true     |
| placeholder    | Placeholder | String | -             | -        |
| General Params | -           | -      | -             | -        |

### textArea

| Field          | Description | Type   | Default Value | Required |
| -------------- | ----------- | ------ | ------------- | -------- |
| type           | Type        | String | 'textArea'    | true     |
| placeholder    | Placeholder | String | -             | -        |
| General Params | -           | -      | -             | -        |

### number

| Field          | Description | Type   | Default Value | Required |
| -------------- | ----------- | ------ | ------------- | -------- |
| type           | Type        | String | 'number'      | true     |
| placeholder    | Placeholder | String | -             | -        |
| General Params | -           | -      | -             | -        |

### radio

| Field               | Description           | Type      | Default Value | Required |
| ------------------- | --------------------- | --------- | ------------- | -------- |
| type                | Type                  | String    | 'radio'       | true     |
| options             | Options               | List<Map> | []            | -        |
| direction           | Options Direction     | String    | 'horizontal'  | -        |
| itemHorizontalSpace | Item Horizontal Space | double    | 16            | -        |
| itemVerticalSpace   | Item Vertical Space   | double    | 8             | -        |
| General Params      | -                     | -         | -             | -        |

### checkbox

| Field               | Description           | Type      | Default Value | Required |
| ------------------- | --------------------- | --------- | ------------- | -------- |
| type                | Type                  | String    | 'checkbox'    | true     |
| options             | Options               | List<Map> | []            | -        |
| direction           | Options Direction     | String    | 'horizontal'  | -        |
| itemHorizontalSpace | Item Horizontal Space | double    | 16            | -        |
| itemVerticalSpace   | Item Vertical Space   | double    | 8             | -        |
| General Params      | -                     | -         | -             | -        |

### select

| Field          | Description     | Type      | Default Value | Required |
| -------------- | --------------- | --------- | ------------- | -------- |
| type           | Type            | String    | 'select'      | true     |
| options        | Options         | List<Map> | []            | -        |
| multiple       | Multiple Select | bool      | false         | -        |
| General Params | -               | -         | -             | -        |

### switch

| Field          | Description | Type   | Default Value | Required |
| -------------- | ----------- | ------ | ------------- | -------- |
| type           | Type        | String | 'switch'      | true     |
| General Params | -           | -      | -             | -        |

### media

| Field          | Description                      | Type   | Default Value | Required |
| -------------- | -------------------------------- | ------ | ------------- | -------- |
| type           | Type                             | String | 'media'       | true     |
| mediaType      | Media Type (media, image, video) | String | 'media'       | -        |
| multiple       | Multiple Uploads                 | bool   | false         | -        |
| General Params | -                                | -      | -             | -        |

#### ios Configuration info.plist

```
<key>NSCameraUsageDescription</key>
<string>Need camera for taking photos or scanning codes</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Need access to photo library for selecting photos or videos</string>
<key>NSMicrophoneUsageDescription</key>
<string>Need microphone access for recording videos</string>
```

#### android Configuration AndroidManifest.xml

```
<uses-permission android:name="android.permission.CAMERA" />
```

### date

| Field | Description | Type   | Default Value | Required |
| ----- | ----------- | ------ | ------------- | -------- |
| type  | Type        | String | 'date'        | true     |

### time

| Field | Description | Type   | Default Value | Required |
| ----- | ----------- | ------ | ------------- | -------- |
| type  | Type        | String | 'time'        | true     |

### datetime

| Field | Description | Type   | Default Value | Required |
| ----- | ----------- | ------ | ------------- | -------- |
| type  | Type        | String | 'datetime'    | true     |

## Layout Types

### row

`row`'s `children` must have `type` as `col`.

| Field    | Description | Type   | Default Value | Required |
| -------- | ----------- | ------ | ------------- | -------- |
| type     | Type        | String | 'row'         | true     |
| gutter   | Spacing     | double | 0             | -        |
| children | Children    | List   | []            | -        |

### col

`col`'s parent must be `row`.

| Field | Description  | Type   | Default Value | Required |
| ----- | ------------ | ------ | ------------- | -------- |
| type  | Type         | String | 'col'         | true     |
| flex  | Flex         | int    | 1             | -        |
| child | Child Config | Map    |               |          |

### group

| Field | Description | Type   | Default Value | Required |
| ----- | ----------- | ------ | ------------- | -------- |
| type  | Type        | String | 'group'       | true     |
| field | Field Name  | String | null          | -        |

## Validation Rules

- required
- type: Shortcut validation type, only supported for text input
  - email
  - url
- min: For string type, it's string length; for number type, it's a specific number; for array type, it's array length
- max: For string type, it's string length; for number type, it's a specific number; for array type, it's array length
- len: For string type, it's string length; for number type, it's a specific number; for array type, it's array length
- pattern: Regex validation
- message: Error message
