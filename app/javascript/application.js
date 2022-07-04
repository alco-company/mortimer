// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "../components"

function findClosest(element, tag){
  if (element.tagName.toLowerCase()==='body')
    return null
  if (element.tagName.toLowerCase()==='form')
    return element
  return findClosest(element.parentElement,tag)
}