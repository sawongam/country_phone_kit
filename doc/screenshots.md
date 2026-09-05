# Screenshots for the pub.dev page

pub.dev shows up to ten screenshots on the package page, declared in
`pubspec.yaml`. They are not generated: they are PNG files committed to the
repository and shipped in the archive.

## Capture

```sh
cd example
flutter run -d macos     # or -d linux, -d windows, or an emulator
```

Two shots are enough, and they are already wired (commented out) in
`pubspec.yaml`:

| File | What to capture |
| --- | --- |
| `doc/screenshot_field.png` | The **Type a number** card with a valid number entered, so the E.164 readout and the green verdict are both visible |
| `doc/screenshot_picker.png` | The country picker open with a search query typed |

Take them on a light theme — pub.dev renders the page light — and crop to the
card rather than the whole window.

## Publish

Uncomment the `screenshots:` block at the bottom of `pubspec.yaml`, check the
paths, and re-run `flutter pub publish --dry-run`.

Constraints pub.dev enforces: PNG or JPEG, at most 4 MB each, and the file must
live inside the published package.
