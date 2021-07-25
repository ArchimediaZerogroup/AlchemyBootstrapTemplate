Rails.application.config.public_file_server.headers = {
  'Surrogate-Control' => 'no-cache',
  'Cache-Control' => 'maxage=315360000, public, no-check',
  'Expires' => 10.year.from_now.httpdate,
  'Date' => 4.days.ago.httpdate,
  'Last-Modified' => 10.days.ago.httpdate
}