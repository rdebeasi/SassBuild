require 'webrick'
require 'sass'
require 'json'
require 'pathname'

if ARGV[0] == 'start'

	port = ARGV[1]
	$auth = ARGV[2]

	class Status < WEBrick::HTTPServlet::AbstractServlet
	def do_GET(request, response)
	
		response.status = 20
		response['Content-Type'] = 'application/json'
		response.body = '{}'

	  end
	end

	class Convert < WEBrick::HTTPServlet::AbstractServlet
	def do_POST(request, response)
	
		if URI.unescape(request.header["auth"][0]) != $auth
			raise 'Bad Auth ' + request.header["auth"][0] + ' ' + $auth
		end
	
		sourceFileName = URI.unescape(request.query['sourceFileName'])
		targetFileName = URI.unescape(request.query['targetFileName'])
		#outputStyle = URI.unescape(request.query['outputStyle'])
		#sourcemap = URI.unescape(request.query['sourcemap'])
        mapFileName = URI.unescape(request.query['mapFileName'])
		
		first = Pathname.new File.dirname(sourceFileName)
		
		begin
			engine = Sass::Engine.for_file(sourceFileName,
				:sourcemap => :file)
			resultCss, resultMap = engine.render_with_sourcemap(File.basename(mapFileName))
		    
			resultMapJson = resultMap.to_json(
				:css_uri => File.basename(targetFileName))
		    
			resultMapObj = JSON.parse(resultMapJson)
			sources = resultMapObj["sources"]
			
			sources.each_with_index{
				|val, index|
				
				path = sources[index].sub! 'file:///', ''
				path = path.gsub! '/', '\\'
				path = URI.unescape(path)
				
				second = Pathname.new path
				relative = second.relative_path_from first
				
				relativePath = relative.split().join('/')
				relativePath = URI.escape(relativePath)
				
				sources[index] = relativePath
			}
			
			resultMapObj["sources"] = sources
			
			resultJson = {
				:css => resultCss,
				:map => resultMapObj}
		    
			#:css_path and :soucemap_path
			#:css_uri => File.basename(sourceFileName)
		    
			response.status = 20
			response['Content-Type'] = 'application/json'
			response.body = JSON.generate(resultJson) 
			
		rescue Sass::SyntaxError => e
			response.status = 20
			response['Content-Type'] = 'application/json'
			response.body = JSON.generate({
				:line => e.sass_line,
				:message => e.message,
				:fileName => e.sass_filename}) 
		end
	  end
	end

	server = WEBrick::HTTPServer.new(:BindAddress => '127.0.0.1', :Port => port)
	server.mount "/status", Status
	server.mount "/convert", Convert
	trap "INT" do server.shutdown end
	server.start

end