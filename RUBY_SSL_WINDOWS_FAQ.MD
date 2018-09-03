# Ruby SSL Troubleshooting for Windows

## Ensure latest 'rubygems'
First of all, make sure you're using the latest _rubygems_ gem. To update it, execute:
```
gem update --system
```

## Errors during 'bundle install'
With the default Ruby installation on Windows (Ruby 2.2 and 2.3) you will most likely encounter errors when executing _bundle install_. They are related to a missing root certificate in the Ruby cert repositories of two gems - _bundler_ and _rubygems_. The omissions affect download of gems from the SumUp gem repository.

### 'Could not verify the SSL certificate for...' error

If you see something like:

```
D:\test-automation>bundle install
Fetching source index from https://maven.internal.sumup.com/content/repositories/rubygems/

Retrying fetcher due to error (2/4): Bundler::Fetcher::CertificateFailureError Could not verify the SSL certificate for https://maven.internal.sumup.com/content/repositories/rubygems/.
There is a chance you are experiencing a man-in-the-middle attack, but most likely your system doesn't have the CA certificates needed for verification. For information about OpenSSL certificates, see http://bit.ly/ruby-ssl. To connect without using SSL, edit your Gemfile sources and change 'https' to 'http'.
Retrying fetcher due to error (3/4): Bundler::Fetcher::CertificateFailureError Could not verify the SSL certificate for https://maven.internal.sumup.com/content/repositories/rubygems/.
There is a chance you are experiencing a man-in-the-middle attack, but most likely your system doesn't have the CA certificates needed for verification. For information about OpenSSL certificates, see http://bit.ly/ruby-ssl. To connect without using SSL, edit your Gemfile sources and change 'https' to 'http'.
Retrying fetcher due to error (4/4): Bundler::Fetcher::CertificateFailureError Could not verify the SSL certificate for https://maven.internal.sumup.com/content/repositories/rubygems/.
There is a chance you are experiencing a man-in-the-middle attack, but most likely your system doesn't have the CA certificates needed for verification. For information about OpenSSL certificates, see http://bit.ly/ruby-ssl. To connect without using SSL, edit your Gemfile sources and change 'https' to 'http'.
Could not verify the SSL certificate for
https://maven.internal.sumup.com/content/repositories/rubygems/.
There is a chance you are experiencing a man-in-the-middle attack, but most likely your system doesn't have the CA certificates needed for verification. For information about OpenSSL certificates, see http://bit.ly/ruby-ssl. To connect without using SSL, edit your Gemfile sources and change 'https' to 'http'.
```

Then this is due to a missing SumUp gem repo certificate in your _bundler_ gem. To solve the error:

1. Locate the installation directory of _bundler_ gem
```
gem which bundler
```
Sample output: `C:/Ruby22/lib/ruby/gems/2.2.0/gems/bundler-1.14.6/lib/bundler.rb`. Careful with the slashes in the address - Windows uses `\` ;)

2. Go to the folder where _bundler.rb_ is located (either in command prompt or Windows Explorer). In this case it will be `C:\Ruby22\lib\ruby\gems\2.2.0\gems\bundler-1.14.6\lib`

3. Now go further down the folder structure into `bundler\ssl_certs` (in our case the whole path will be `C:\Ruby22\lib\ruby\gems\2.2.0\gems\bundler-1.14.6\lib\bundler\ssl_certs`)

4. Create a folder titled `maven.internal.sumup.com` (`C:\Ruby22\lib\ruby\gems\2.2.0\gems\bundler-1.14.6\lib\bundler\ssl_certs\maven.internal.sumup.com`)

5. Copy the file `installation\GeoTrustPrimaryCertificationAuthority-G3.pem` from this project into the newly created _maven.internal.sumup.com_ folder

6. Try to enjoy ;-)

Having done the previous step and runnung _bundle install_ again you will most likely hit the next Ruby flaw...

### 'Gem::RemoteFetcher::FetchError: SSL_connect returned=1 errno=0 state=error: certificate verify failed' error
After fixing _bundler_ you will most probably hit one more missing certificate. If your output is:

```
D:\test-automation>bundle install
Fetching gem metadata from https://maven.internal.sumup.com/content/repositories/rubygems/.........
Fetching gem metadata from https://maven.internal.sumup.com/content/repositories/gems/.........
Fetching version metadata from https://maven.internal.sumup.com/content/repositories/rubygems/..
Fetching version metadata from https://maven.internal.sumup.com/content/repositories/gems/..
Using bundler 1.14.6
Gem::RemoteFetcher::FetchError: SSL_connect returned=1 errno=0 state=error:
certificate verify failed
(https://maven.internal.sumup.com/content/repositories/gems/gems/i18n-0.8.1.gem)
An error occurred while installing i18n (0.8.1), and Bundler cannot continue.
Make sure that `gem install i18n -v '0.8.1'` succeeds before bundling.
```

Then _rubygems_ needs a certificate kick in its SSL storage back:

1. Locate the installation directory of _rubygems_ gem
```
gem which rubygems
```
Sample output: `C:/Ruby22/lib/ruby/site_ruby/2.2.0/rubygems.rb`. Careful with the slashes in the address - Windows uses `\` ;)

**NOTE** Depending on your setup, the installation path of _rubygems_ may be `C:/Ruby22/lib/ruby/2.2.0/rubygems.rb` (here we have _lib/ruby/2.2.0_ and not _lib/ruby/**site_ruby** 
/2.2.0_). This means that you have not (or did not need to) update your _rubygems_. Pay attention to Step 4!

2. Go to the folder where _rubygems.rb_ is located (either in command prompt or Windows Explorer). In this case it will be `C:\Ruby22\lib\ruby\site_ruby\2.2.0`

3. Now go further down the folder structure into `rubygems\ssl_certs` (in our case the whole path will be `C:\Ruby22\lib\ruby\site_ruby\2.2.0\rubygems\ssl_certs`)

4. In this step you may or may not need to create a subfolder `maven.internal.sumup.com`. Depending on whether you updated _rubygems_.
  - If _ssl_certs_ folder **includes only .pem files, then skip this step**
  - If _ssl_certs_ folder **includes other subfolders like _rubygems.org_, then create a subfolder named** `maven.internal.sumup.com`

5. Copy the file `installation\GeoTrustPrimaryCertificationAuthority-G3.pem` from this project into the newly created _maven.internal.sumup.com_ folder

6. Enjoy :)