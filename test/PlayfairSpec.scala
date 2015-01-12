/**
 * Created by Yakov Boglev on 11/01/2015.
 */

import org.scalatest.FlatSpec
import playfair.Playfair._

class PlayfairSpec extends FlatSpec {

  /**
   * Test the behaviour of checkKeyword. This should accept words or phrases with letters only
   * and can include spaces (in addition to letters). In this case it should return a Success[String];
   * in all other cases it should return a Failure[String],
   */
  behavior of "a keyword"

  it must "not be an empty string" in {
    assert(checkKeyword("").isFailure)
  }
  it must "not consist solely of spaces" in {
    assert(checkKeyword("   ").isFailure)
  }
  it must "not contain any non-letter characters (except spaces)" in {
    assert(checkKeyword("my-keyword").isFailure)
  }
  it can "be a long string that includes spaces" in {
    val longKey = "this is a very long keyword that I would like to use"
    assert(checkKeyword(longKey).get === longKey.filter(c => !c.isSpaceChar))
  }
  it can "be a single word" in {
    val k = "keyword"
    assert(checkKeyword(k).get === k)
  }
  it can "be the word Pennsylvania" in {
    val k = "Pennsylvania"
    assert(checkKeyword(k).get === k)
  }

  /**
   * Test the behaviour of the file getting methods. A correctly specified file should return true
   * while an incorrectly specified file (or invalid file) should return false.
   */

  behavior of "the loading and checking of a source file for ENCODING"

  it should "return false if file for ENCODING is not properly requested" in {
    val f = obtainFileFromUser("badFileName")
    assert(checkFileValidForEncoding(f) === false)
  }
  it should "return false if file for ENCODING is properly requested but file is empty" in {
    val f = obtainFileFromUser("invalid-empty.txt")
    assert(checkFileValidForEncoding(f) === false)
  }
  it should "return false if file for ENCODING is properly requested but contains no valid text" in {
    val f = obtainFileFromUser("invalid-noletters.txt")
    assert(checkFileValidForEncoding(f) === false)
  }
  it should "return false if file for ENCODING is properly requested but contains fewer than two letters" in {
    val f = obtainFileFromUser("invalid-oneletter.txt")
    assert(checkFileValidForEncoding(f) === false)
  }
  it should "return true if file for ENCODING is properly requested and contains valid but meaningless text" in {
    val f = obtainFileFromUser("valid-twoletters.txt")
    assert(checkFileValidForEncoding(f) === true)
  }
  it should "return true if file for ENCODING is properly requested and contains valid text (wiki text)" in {
    val f = obtainFileFromUser("wiki-plaintext.txt")
    assert(checkFileValidForEncoding(f) === true)
  }
  it should "return true if file for ENCODING is properly requested and contains valid text (ProgPara text)" in {
    val f = obtainFileFromUser("ppl-plaintext.txt")
    assert(checkFileValidForEncoding(f) === true)
  }

  behavior of "the loading and checking of a source file for DECODING"

  it should "return false if file for DECODING is not properly requested" in {
    val f = obtainFileFromUser("badFileName")
    assert(checkFileValidForDecoding(f) === false)
  }
  it should "return false if file for DECODING is properly requested but file is empty" in {
    val f = obtainFileFromUser("invalid-empty.txt")
    assert(checkFileValidForDecoding(f) === false)
  }
  it should "return false if file for DECODING is properly requested but contains anything but letters, spaces and newlines" in {
    val f = obtainFileFromUser("invalid-noletters.txt")
    assert(checkFileValidForDecoding(f) === false)
  }
  it should "return false if file for DECODING is properly requested but contains fewer than two letters" in {
    val f = obtainFileFromUser("invalid-oneletter.txt")
    assert(checkFileValidForDecoding(f) === false)
  }
  it should "return true if file for DECODING is properly requested and has an even number of letters" in {
    val f = obtainFileFromUser("invalid-oddNumSecrettext1.txt")
    assert(checkFileValidForDecoding(f) === false)
  }
  it should "return false if file for DECODING is properly requested but has an odd number of letters" in {
    val f = obtainFileFromUser("invalid-oddNumSecrettext2.txt")
    assert(checkFileValidForDecoding(f) === false)
  }

}
