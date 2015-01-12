package playfair

/**
 * Created by Yakov Boglev on 12/01/2015.
 */
class Coder(keyword: String) {
  val alphabet = "abcdefghiklmnopqrstuvwxyz".toList
  val rowBounds = Array(0, 5, 10, 15, 20)

  def encode(plaintText: String): String = ???

  def decode(secretText: String): String = ???

  def createCodeBlock(): Array[Char] = {
    def blockHelper(lst: List[Char]): List[Char] = lst match {
      case Nil        => lst
      case h :: rest  => h :: blockHelper(lst.tail.filter(_ != h))
    }
    blockHelper(keyword.toLowerCase.toList).toArray
  }
}
